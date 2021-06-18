#!/usr/bin/env python3

"""
ifsitegen.py: Generate a playable IF web site for a Z-code/Glulx game
Created by Andrew Plotkin (erkyrath@eblong.com)
Last updated: April 19, 2021
This script is in the public domain.

This script does essentially the same job as the "Release along
with an interpreter" option of Inform 7. The differences are:

- You can run this on *any* Z-code or Glulx game file.
- It generates the playable game page as the primary page, rather
  than starting with a game information page. (The playable game is
  at index.html, not play.html.)

This is useful for making Inform 6 games and older games available on
a web site. It can also make a playable Glulx file with images, which
Inform 7 (as of 6M62) cannot.

File types supported: .z3 through .z8, .ulx, .zblorb, .gblorb

You must install Inform 7 to use this script. (It relies on template
files that are distributed as part of Inform 7.) However, you don't
need to *run* Inform 7.

The Parchment and Quixe interpreters included in Inform are somewhat
old (as of I7 6M62). You may want to download the latest versions:

    https://github.com/curiousdannii/parchment/raw/ifcomp/dist/inform7/parchment-for-inform7.zip
    https://eblong.com/zarf/glulx/quixe/Quixe.zip

---

The simplest way to use this tool:

    python3 ifsitegen.py Game.ulx

This will look for Inform 7 in its default installation location (on
your OS). It will use the "Standard" web site template and the "Quixe"
or "Parchment" interpreter, depending on the game file type. If you
have installed updated templates in your Inform document library,
those will be used instead.

The "Standard" template includes the game title and author on the page.
You should supply these:

    python3 ifsitegen.py --author 'Bob Zod' --title 'Pow!' Game.ulx

If you provide a Blorb file which contains cover art, that will be
used on the web page. Otherwise, you can use the --cover argument:

    python3 ifsitegen.py --cover my-cover-art.jpeg Game.ulx

If you have installed Inform 7 in a non-standard place, or given it
a non-standard name, you must pass this with the -a argument:

    python3 ifsitegen.py -a /Applications/Local/I7.app Game.ulx

Similarly, you can use the -l argument to refer to your document library
directory.

Default locations:
- MacOS:   /Applications/Inform.app,  ~/Library/Inform
- Windows: C:\Program Files\Inform 7, ~\My Documents\Inform
- Linux:   /usr/local/share/inform7,  ~/Inform

You can select a different web site template with the -w option, or a
different interpreter template with the -i option:

    python3 ifsitegen.py -i Vorple -w Classic Game.ulx

(For more information about Inform's templates, see chapters 25.10-25.14
of the Inform manual.)

The -i and -w options can also refer to a directory or a zip file containing
a template:

    python3 ifsitegen.py -i ~/Downloads/Quixe-220.zip Game.ulx

Finally, if you have a Glulx game with images, pass the --unpack option
to unpack the .gblorb file into separate image files. This is not required!
The game will play fine either way. However, --unpack reduces the processing
and memory load on the client browser.

"""

import sys
import os
import os.path
import optparse
import io
import re
import zipfile
import struct
import base64
import json
from chunk import Chunk
from collections import OrderedDict

MANIFEST_FILE = '(manifest).txt'
ZCODE = 'Z-code'
GLULX = 'Glulx'

popt = optparse.OptionParser(usage='ifsitegen.py [ options ] GAME')

popt.add_option('-a', '--app', '--application',
                action='store', dest='app', metavar='DIR',
                help='Inform application')
popt.add_option('-l', '--lib', '--library',
                action='store', dest='lib', metavar='DIR',
                help='Inform document library')
popt.add_option('-w', '--website',
                action='store', dest='website', metavar='TEMPLATE',
                help='website template package or directory')
popt.add_option('-i', '--terp', '--interpreter',
                action='store', dest='terp', metavar='TEMPLATE',
                help='interpreter template package or directory')
popt.add_option('-r', '--release',
                action='store', dest='release', metavar='DIR',
                default='Release',
                help='destination directory (default: Release)')
popt.add_option('--title',
                action='store', dest='title',
                help='game title')
popt.add_option('--author',
                action='store', dest='author',
                help='game author')
popt.add_option('--cover',
                action='store', dest='cover',
                help='cover image (should be square)')
popt.add_option('--unpack',
                action='store_true', dest='unpack',
                help='unpack Blorb resources into separate files')

(opts, args) = popt.parse_args()

def locate_dirs():
    """Identify the application and library directories for this OS.
    What we actually want are the Templates directory within Inform 7
    and the Templates directory in the Inform library folder.

    This relies on the --app and --lib arguments, if provided. We
    try to interpret them liberally. For example, --app could be either
    the pathname of the Inform 7 application or the directory that
    contains it. Either argument may include or exclude the Templates
    component.

    Returns (appdir, libdir).
    """
    
    appdir = opts.app
    libdir = opts.lib

    if not libdir:
        if sys.platform == 'darwin':
            path = os.path.join(os.environ['HOME'], 'Library/Inform')
            if os.path.isdir(path):
                libdir = path
        elif sys.platform == 'win32':
            path = 'C:\\Program Files (x86)\\Inform 7\\Internal\\Templates'
            if os.path.isdir(path):
                libdir = path
        else:
            path = os.path.join(os.environ['HOME'], 'Inform')
            if os.path.isdir(path):
                libdir = path

    if libdir:
        path = os.path.join(libdir, 'Templates')
        if os.path.isdir(path):
            libdir = path

    if not appdir:
        if sys.platform == 'darwin':
            path = '/Applications/Inform.app'
            if os.path.isdir(path):
                appdir = path
        elif sys.platform == 'win32':
            path = 'C:\\Program Files (x86)\\Inform 7'
        else:
            path = '/usr/local/share/inform7'
            if os.path.isdir(path):
                appdir = path
            
    if appdir:
        if sys.platform == 'darwin':
            path = os.path.join(appdir, 'Inform.app')
            if os.path.isdir(path):
                appdir = path
            path = os.path.join(appdir, 'Contents/Resources')
            if os.path.isdir(path):
                appdir = path
            path = os.path.join(appdir, 'Internal')
            if os.path.isdir(path):
                appdir = path
        elif sys.platform == 'win32':
            path = os.path.join(appdir, 'Inform 7')
            if os.path.isdir(path):
                appdir = path
            path = os.path.join(appdir, 'Internal')
            if os.path.isdir(path):
                appdir = path
        else:
            path = os.path.join(appdir, 'inform7')
            if os.path.isdir(path):
                appdir = path
            path = os.path.join(appdir, 'Internal')
            if os.path.isdir(path):
                appdir = path
    
    if appdir:
        path = os.path.join(appdir, 'Templates')
        if os.path.isdir(path):
            appdir = path

    return appdir, libdir

def find_terp_template(path, appdir=None, libdir=None, gametype=None):
    """Attempt to find the right interpreter template. The path argument
    (poorly named) may be:
    
    - None: Use the default Quixe or Parchment interpreter, based on
      gametype.
    - A name like "Quixe", "Parchment", or "Vorple": Find this in the
      library or application path.
    - A directory name containing a template.
    - A zip file containing a template.

    Returns a Template object containing a Manifest.
    """
    defaultterp = None
    if gametype == ZCODE:
        defaultterp = 'Parchment'
    elif gametype == GLULX:
        defaultterp = 'Quixe'

    if path and not os.path.split(path)[0]:
        # The path has no slashes; try reading it as a dir in appdir/libdir
        if libdir:
            tpath = os.path.join(libdir, path)
            manpath = os.path.join(tpath, MANIFEST_FILE)
            if os.path.isfile(manpath):
                return Template(dir=tpath, manpath=manpath)
        if appdir:
            tpath = os.path.join(appdir, path)
            manpath = os.path.join(tpath, MANIFEST_FILE)
            if os.path.isfile(manpath):
                return Template(dir=tpath, manpath=manpath)

    if path is None and defaultterp:
        # Look for "Parchment/Quixe" in appdir/libdir
        if libdir:
            tpath = os.path.join(libdir, defaultterp)
            manpath = os.path.join(tpath, MANIFEST_FILE)
            if os.path.isfile(manpath):
                return Template(dir=tpath, manpath=manpath)
        if appdir:
            tpath = os.path.join(appdir, defaultterp)
            manpath = os.path.join(tpath, MANIFEST_FILE)
            if os.path.isfile(manpath):
                return Template(dir=tpath, manpath=manpath)
        
    if path and os.path.isfile(path):
        if not path.endswith('.zip'):
            print('Warning: template does not appear to be a zip package: %s' % (path,))
        zip = zipfile.ZipFile(path)
        ls = zip.namelist()
        for val in ls:
            head, sep, tail = val.rpartition('/')
            if tail == MANIFEST_FILE:
                return Template(zip=zip, prefix=head, manpath=val)
        else:
            raise Exception('Unable to find manifest in zip template: %s' % (path,))
    elif path and os.path.isdir(path):
        manpath = os.path.join(path, MANIFEST_FILE)
        if os.path.isfile(manpath):
            return Template(dir=path, manpath=manpath)
        elif defaultterp:
            tpath = os.path.join(path, defaultterp)
            manpath = os.path.join(tpath, MANIFEST_FILE)
            if os.path.isfile(manpath):
                return Template(dir=tpath, manpath=manpath)
        raise Exception('Unable to locate template: %s' % (path,))

    if path is None:
        raise Exception('Unable to locate template')
    raise Exception('Unable to read template: %s' % (path,))

def find_web_template(path, appdir=None, libdir=None):
    """Attempt to find the right web site template. The path argument
    (poorly named) may be:
    
    - None: Use the default Standard template.
    - A name like "Standard" or "Classic": Find this in the library or
      application path.
    - A directory name containing a template.
    - A zip file containing a template.

    Returns a Template object.
    """
    if path and not os.path.split(path)[0]:
        # The path has no slashes; try reading it as a dir in appdir/libdir
        if libdir:
            tpath = os.path.join(libdir, path)
            if os.path.isdir(tpath):
                return Template(dir=tpath)
        if appdir:
            tpath = os.path.join(appdir, path)
            if os.path.isdir(tpath):
                return Template(dir=tpath)

    if path is None:
        # Look for "Standard" in appdir/libdir
        if libdir:
            tpath = os.path.join(libdir, 'Standard')
            if os.path.isdir(tpath):
                return Template(dir=tpath)
        if appdir:
            tpath = os.path.join(appdir, 'Standard')
            if os.path.isdir(tpath):
                return Template(dir=tpath)
        
    if path and os.path.isfile(path):
        if not path.endswith('.zip'):
            print('Warning: template does not appear to be a zip package: %s' % (path,))
        zip = zipfile.ZipFile(path)
        prefix = None
        ls = zip.namelist()
        if ls and ls[0] and ls[0].endswith('/'):
            prefix = ls[0][:-1]
        return Template(zip=zip, prefix=prefix)
    elif path and os.path.isdir(path):
        return Template(dir=path)
        raise Exception('Unable to locate template: %s' % (path,))

    if path is None:
        raise Exception('Unable to locate template')
    raise Exception('Unable to read template: %s' % (path,))


class Template:
    """Information about a template (interpreter or web site).
    Really this is just a bunch of files, but they might be packaged
    in a zip file.

    You must provide either the dir argument (pathname to a directory)
    or the zip argument (an open ZipFile handle).

    If manpath is provided, this is the "(manifest).txt" file for
    an interpreter template.
    """
    def __init__(self, dir=None, zip=None, prefix=None, manpath=None):
        # list of (origpath, destfile)
        self.files = []
        
        if dir is not None:
            self.iszip = False
            self.dir = dir
            for ent in os.scandir(dir):
                if not ent.is_file():
                    continue
                if ent.name == MANIFEST_FILE:
                    continue
                self.files.append( (ent.path, ent.name) )
        elif zip is not None:
            self.iszip = True
            self.zip = zip
            for path in zip.namelist():
                val = path
                if prefix:
                    if not val.startswith(prefix):
                        continue
                    val = val[ len(prefix) : ]
                    if val.startswith('/'):
                        val = val[ 1 : ]
                if not val:
                    continue
                if val == MANIFEST_FILE:
                    continue
                self.files.append( (path, val) )
        else:
            raise Exception('Template must have zip or dir')

        self.manifest = None
        if manpath:
            if not self.iszip:
                manfile = open(manpath, 'r')
            else:
                manfile = zip.open(manpath)
                manfile = io.TextIOWrapper(manfile)
            self.manifest = Manifest(manfile)

    def __repr__(self):
        if not self.iszip:
            return '<Template (dir): %s>' % (self.dir,)
        else:
            return '<Template (zip): %s>' % (self.zip.filename,)

    def shortname(self):
        """Return the base filename for this package (Quixe or Quixe.zip).
        """
        if not self.iszip:
            val = self.dir
        else:
            val = self.zip.filename
        return os.path.split(val)[1]

    def getfile(self, path, text=False):
        """Return the contents of the file with the given pathname.
        Returns bytes or string, depending on the text argument.
        """
        if not self.iszip:
            if not text:
                fl = open(path, 'rb')
                dat = fl.read()
                fl.close()
            else:
                fl = open(path, 'r')
                dat = fl.read()
                fl.close()
            return dat
        else:
            fl = self.zip.open(path)
            dat = fl.read()
            fl.close()
            if text:
                dat = dat.decode()
            return dat

class Manifest:
    """The contents of the (manifest).txt file from an interpreter template
    This consists of a bunch of metadata entries plus a list of filenames.
    """
    def __init__(self, file=None):
        self.body = []
        self.metadata = {}

        if file:
            self.load(file)

    def get_meta(self, key):
        """Get a metadata entry as a list of lines.
        """
        return self.metadata.get(key, [])

    def get_meta_line(self, key, defval=None):
        """Get a one-line metadata entry, as a string.
        """
        ls = self.metadata.get(key)
        if not ls:
            return defval
        return ls[0]

    def load(self, file):
        """Parse a (manifest).txt file. The argument is an open file
        stream.
        """
        section = None
        
        for ln in file.readlines():
            ln = ln.rstrip()
            
            if ln.startswith('[') and ln.endswith(']'):
                key = ln[1:-1]
                if not key:
                    section = None
                    continue
                section = []
                self.metadata[key] = section
                continue

            if section is None:
                if not ln or ln.startswith('!'):
                    continue
                self.body.append(ln)
            else:
                section.append(ln)

def identify_gamefile(filename):
    """Figure out whether the file is Z-code or Glulx, or a Blorb file
    containing one of those.
    Return a Game object.
    """
    fl = open(filename, 'rb')
    dat = fl.read(4)
    fl.seek(0)
    
    if dat == b'Glul':
        return Game(fl, GLULX)
    if dat[0] in (3, 4, 5, 6, 7, 8):
        return Game(fl, ZCODE)

    if dat == b'FORM':
        fl.close()
        fl = BlorbFile(filename)
        chunk = fl.usagemap.get( (b'Exec', 0) )
        if not chunk:
            raise Exception('No executable chunk: %s' % (filename,))
        if chunk.type == b'GLUL':
            return Game(fl, GLULX, isblorb=True)
        if chunk.type == b'ZCOD':
            return Game(fl, ZCODE, isblorb=True)
        raise Exception('Unrecognized executable chunk (%s): %s' % (typestring(chunk.type), filename,))

    raise Exception('File not recognized: %s' % (filename,))

class Game:
    """Information about a game file.
    """
    def __init__(self, file, type, isblorb=False):
        self.file = file
        self.type = type
        self.isblorb = isblorb

def do_release(filename, game, terp_template, web_template, release):
    """Generate the Release directory.
    """
    manifest = terp_template.manifest
    basefilename = os.path.split(filename)[1]
    jsfilename = basefilename+'.js'
    unpacking = False

    if game.isblorb and opts.unpack:
        unpacking = True
        val = basefilename.rpartition('.')[0]
        typ = '.zcode' if game.type == ZCODE else '.ulx'
        jsfilename = val+typ+'.js'

    # Locate the play.html file, which we will use as index.html.
    playpath = None
    for (path, name) in web_template.files:
        if name == 'play.html':
            playpath = path
            break
    if playpath is None:
        print('No play.html in web template')
        return

    # Prepare the tag substitution map.
    map = {}
    
    # Copy all the fields out of the interpreter manifest.
    for key, ls in manifest.metadata.items():
        map[key] = '\n'.join(ls)

    # Add a few more fields.
    map['ENCODEDSTORYFILE'] = htmlencode(jsfilename)
    map['TITLE'] = htmlencode(opts.title or 'TITLE?')
    map['AUTHOR'] = htmlencode(opts.author or 'AUTHOR?')
    map['DOWNLOAD'] = '<a href="%s">Game file</a>' % (htmlencode(basefilename),)
    map['COVER'] = ''
    coverdat = None
    covername = None

    # Try to extract a cover image from the blorb file.
    if game.isblorb and not opts.cover:
        ls = game.file.chunkmap.get(b'Fspc')
        if ls:
            chunk = ls[0]
            dat = chunk.data()
            index = struct.unpack('>I', dat[0:4])[0]
            chunk = game.file.usagemap.get( (b'Pict', index) )
            coverdat = chunk.data()
            if chunk.type == b'JPEG':
                covername = 'Cover.jpeg'
            elif chunk.type == b'PNG ':
                covername = 'Cover.png'
            else:
                coverdat = None
                print('Unrecognized cover chunk type: %s' % (chunk.type,))

    # Use the --cover argument.
    if opts.cover:
        covername = os.path.split(opts.cover)[1]
        fl = open(opts.cover, 'rb')
        coverdat = fl.read()
        fl.close()

    if covername and coverdat:
        val = htmlencode(covername)
        map['COVER'] = '<a href="%s"><img src="%s" width="120" height="120" border="1"></a>' % (val, val, )
    
    if not os.path.exists(release):
        os.mkdir(release)

    pat_tag = re.compile('\\[([A-Z_]+)\\]')
    def subst(match):
        key = match.group(1)
        val = map.get(key)
        if val is not None:
            return val
        return '[?'+key+'?]'

    # Transform the web template's play.html file.
    dat = web_template.getfile(playpath, text=True)
    # Replace the "Home page" link with a "Game file" link.
    pat_indexhtml = re.compile('<a href="index.html">[^<>]*</a>')
    dat = pat_indexhtml.sub('[DOWNLOAD]', dat)
    # Perform tag substitutions until there are no more.
    while pat_tag.search(dat):
        dat = pat_tag.sub(subst, dat)
    # Write out as index.html.
    fl = open(os.path.join(release, 'index.html'), 'w')
    fl.write(dat)
    fl.close()

    # Copy over all the non-HTML web template files. (The CSS, basically.)
    for (path, name) in web_template.files:
        if name.endswith('.html'):
            continue
        dat = web_template.getfile(path)
        fl = open(os.path.join(release, name), 'wb')
        fl.write(dat)
        fl.close()

    # Copy over the cover image, if supplied.
    if covername and coverdat:
        fl = open(os.path.join(release, covername), 'wb')
        fl.write(coverdat)
        fl.close()
        coverdat = None

    tpath = os.path.join(release, 'interpreter')
    if not os.path.exists(tpath):
        os.mkdir(tpath)

    # Copy over all the interpreter template files.
    for (path, name) in terp_template.files:
        # We're ignoring the list in the manifest, but it should be the same.
        dat = terp_template.getfile(path)
        fl = open(os.path.join(tpath, name), 'wb')
        fl.write(dat)
        fl.close()

    if unpacking:
        alttexts = {}
        ls = game.file.chunkmap.get(b'RDes')
        if (ls):
            chunk = ls[0]
            alttexts = analyze_resourcedescs(chunk)
        
        outfl = open(os.path.join(tpath, 'resourcemap.js'), 'w')
        outfl.write('/* resourcemap.js generated by ifsitegen.py */\n')
        outfl.write('StaticImageInfo = {\n')
        usages = [ (num, chunk) for (use, num, chunk) in game.file.usages if (use == b'Pict') ]
        usages.sort()   # on num
        first = True
        wholemap = OrderedDict()
        for (num, chunk) in usages:
            try:
                (suffix, size) = analyze_pict(chunk)
            except Exception as ex:
                print('Error on Pict chunk %d: %s' % (num, ex))
                continue
            picfilename = 'pict-%d.%s' % (num, suffix)
            map = OrderedDict()
            map['image'] = num
            map['url'] = 'interpreter/'+picfilename
            if (b'Pict', num) in alttexts:
                map['alttext'] = alttexts.get( (b'Pict',num) ).decode('utf-8')
            map['width'] = size[0]
            map['height'] = size[1]
            wholemap['pict-%d' % (num,)] = map
            indexdat = json.dumps(map, indent=2)
            if (first):
                first = False
            else:
                outfl.write(',\n')
            outfl.write('%d: %s\n' % (num, indexdat))
            outfl2 = open(os.path.join(tpath, picfilename), 'wb')
            if (chunk.formtype and chunk.formtype != b'FORM'):
                outfl2.write(b'FORM')
                outfl2.write(struct.pack('>I', chunk.len))
            outfl2.write(chunk.data())
            outfl2.close()
        outfl.write('};\n')
        outfl.close()
        
    # Copy over the game file.
    fl = open(filename, 'rb')
    dat = fl.read()
    fl.close()

    fl = open(os.path.join(release, basefilename), 'wb')
    fl.write(dat)
    fl.close()

    # And its base64 (.js) clone.
    if unpacking:
        # Unpack the game file from the blorb.
        chunk = game.file.usagemap.get( (b'Exec', 0) )
        dat = chunk.data()
        
    dat = base64.b64encode(dat)
    fl = open(os.path.join(tpath, jsfilename), 'w')
    lines = manifest.get_meta('BASESIXTYFOURTOP')
    fl.write('\n'.join(lines))
    fl.write(dat.decode())
    lines = manifest.get_meta('BASESIXTYFOURTAIL')
    fl.write('\n'.join(lines))
    fl.write('\n')
    fl.close()

    print('Wrote playable game to:', release)

# The BlorbChunk and BlorbFile classes are copied from blorbtool.py.
# See: https://eblong.com/zarf/blorb/blorbtool.py
    
class BlorbChunk:
    def __init__(self, blorbfile, typ, start, len, formtype=None):
        self.blorbfile = blorbfile
        self.type = typ
        self.start = start
        self.len = len
        self.formtype = formtype
        self.literaldata = None
        self.filedata = None
        self.filestart = None
        
    def __repr__(self):
        return '<BlorbChunk %s at %d, len %d>' % (typestring(self.type), self.start, self.len)
    
    def data(self, max=None):
        if (self.literaldata):
            if (max is not None):
                return self.literaldata[0:max]
            else:
                return self.literaldata
        if (self.filedata):
            fl = open(self.filedata, 'rb')
            if (self.filestart is not None):
                fl.seek(self.filestart)
            if (max is not None):
                dat = fl.read(max)
            else:
                dat = fl.read()
            fl.close()
            return dat
        self.blorbfile.formchunk.seek(self.start)
        toread = self.len
        if (max is not None):
            toread = min(self.len, max)
        return self.blorbfile.formchunk.read(toread)

class BlorbFile:
    def __init__(self, filename):
        self.chunks = []
        self.chunkmap = {}
        self.chunkatpos = {}
        self.usages = []
        self.usagemap = {}
        
        self.filename = filename

        self.file = open(filename, 'rb')
        formchunk = Chunk(self.file)
        self.formchunk = formchunk
        
        if (formchunk.getname() != b'FORM'):
            raise Exception('This does not appear to be a Blorb file.')
        formtype = formchunk.read(4)
        if (formtype != b'IFRS'):
            raise Exception('This does not appear to be a Blorb file.')
        formlen = formchunk.getsize()
        while formchunk.tell() < formlen:
            chunk = Chunk(formchunk)
            start = formchunk.tell()
            size = chunk.getsize()
            formtype = None
            if chunk.getname() == b'FORM':
                formtype = chunk.read(4)
            subchunk = BlorbChunk(self, chunk.getname(), start, size, formtype)
            self.chunks.append(subchunk)
            chunk.skip()
            chunk.close()

        for chunk in self.chunks:
            self.chunkatpos[chunk.start] = chunk
            dict_append(self.chunkmap, chunk.type, chunk)

        # Sanity checks. Also get the usage list.
        
        ls = self.chunkmap.get(b'RIdx')
        if (not ls):
            raise Exception('No resource index chunk!')
        elif (len(ls) != 1):
            print('Warning: too many resource index chunks!')
        else:
            chunk = ls[0]
            if (self.chunks[0] is not chunk):
                print('Warning: resource index chunk is not first!')
            dat = chunk.data()
            numres = struct.unpack('>I', dat[0:4])[0]
            if (numres*12+4 != chunk.len):
                print('Warning: resource index chunk has wrong size!')
            for ix in range(numres):
                subdat = dat[4+ix*12 : 16+ix*12]
                typ = struct.unpack('>4c', subdat[0:4])
                typ = b''.join(typ)
                num = struct.unpack('>I', subdat[4:8])[0]
                start = struct.unpack('>I', subdat[8:12])[0]
                subchunk = self.chunkatpos.get(start)
                if (not subchunk):
                    print('Warning: resource (%s, %d) refers to a nonexistent chunk!' % (typestring(typ), num))
                self.usages.append( (typ, num, subchunk) )
                self.usagemap[(typ, num)] = subchunk

    def close(self):
        if (self.formchunk):
            self.formchunk.close()
            self.formchunk = None
        if (self.file):
            self.file.close()
            self.file = None

    def chunk_position(self, chunk):
        try:
            return self.chunks.index(chunk)
        except:
            return None

# A few miscellaneous utilities

def dict_append(map, key, val):
    ls = map.get(key)
    if (not ls):
        ls = []
        map[key] = ls
    ls.append(val)

def typestring(dat):
    return "'" + dat.decode() + "'"

def bytes_to_intarray(dat):
    return [ val for val in dat ]

def intarray_to_bytes(arr):
    return bytes(arr)
    
def htmlencode(val):
    val = val.replace('&', '&amp;')
    val = val.replace('<', '&lt;')
    val = val.replace('>', '&gt;')
    val = val.replace('"', '&quot;')
    return val

def analyze_resourcedescs(chunk):
    res = {}
    dat = chunk.data()
    (subdat, dat) = (dat[:4], dat[4:])
    count = struct.unpack('>I', subdat)[0]
    for ix in range(count):
        if (len(dat) < 12):
            break
        (subdat, dat) = (dat[:12], dat[12:])
        subls = struct.unpack('>4c2I', subdat)
        usage = b''.join(subls[0:4])
        strlen = subls[-1]
        num = subls[-2]
        if (len(dat) < strlen):
            break
        (subdat, dat) = (dat[:strlen], dat[strlen:])
        res[(usage, num)] = subdat
    return res
    
def analyze_pict(chunk):
    if (chunk.type == b'JPEG'):
        size = parse_jpeg(chunk.data())
        return ('jpeg', size)
    if (chunk.type == b'PNG '):
        size = parse_png(chunk.data())
        return ('png', size)
    raise Exception('Unrecognized Pict type: %s' % (chunk.type,))

def parse_png(dat):
    dat = bytes_to_intarray(dat)
    pos = 0
    sig = dat[pos:pos+8]
    pos += 8
    if sig != [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]:
        raise Exception('PNG signature does not match')
    while pos < len(dat):
        clen = (dat[pos] << 24) | (dat[pos+1] << 16) | (dat[pos+2] << 8) | dat[pos+3]
        pos += 4
        ctyp = intarray_to_bytes(dat[pos:pos+4])
        pos += 4
        #print('Chunk:', ctyp, 'len', clen)
        if ctyp == b'IHDR':
            width  = (dat[pos] << 24) | (dat[pos+1] << 16) | (dat[pos+2] << 8) | dat[pos+3]
            pos += 4
            height = (dat[pos] << 24) | (dat[pos+1] << 16) | (dat[pos+2] << 8) | dat[pos+3]
            pos += 4
            return (width, height)
        pos += clen
        pos += 4
    raise Exception('No PNG header block found')

def parse_jpeg(dat):
    dat = bytes_to_intarray(dat)
    #print('Length:', len(dat))
    pos = 0
    while pos < len(dat):
        if dat[pos] != 0xFF:
            raise Exception('marker is not FF')
        while dat[pos] == 0xFF:
            pos += 1
        marker = dat[pos]
        pos += 1
        if marker == 0x01 or (marker >= 0xD0 and marker <= 0xD9):
            #print('FF%02X*' % (marker,))
            continue
        clen = (dat[pos] << 8) | dat[pos+1]
        #print('FF%02X, len %d' % (marker, clen))
        if (marker >= 0xC0 and marker <= 0xCF and marker != 0xC8):
            if clen <= 7:
                raise Exception('SOF block is too small')
            bits = dat[pos+2]
            height = (dat[pos+3] << 8) | dat[pos+4]
            width  = (dat[pos+5] << 8) | dat[pos+6]
            return (width, height)
        pos += clen
    raise Exception('SOF block not found')


# Do the work!

if len(args) != 1:
    popt.print_help()
    sys.exit(-1)

filename = args[0]
try:
    game = identify_gamefile(filename)
except Exception as ex:
    print(ex)
    sys.exit(1)

print('%s file (%s): %s' % (game.type, ('Blorb' if game.isblorb else 'plain'), filename,))

(appdir, libdir) = locate_dirs()

try:
    terp_template = find_terp_template(opts.terp, appdir=appdir, libdir=libdir, gametype=game.type)
except Exception as ex:
    print(ex)
    sys.exit(-1)

try:
    web_template = find_web_template(opts.website, appdir=appdir, libdir=libdir)
except Exception as ex:
    print(ex)
    sys.exit(-1)

val = terp_template.manifest.get_meta_line('INTERPRETERVERSION')
print('Interpreter: %s' % (val,))
print('Website: %s' % (web_template.shortname(),))

val = terp_template.manifest.get_meta_line('INTERPRETERVM', '')
if game.type == GLULX and 'g' not in val:
    print('Warning: Template does not appear to support Glulx')
if game.type == ZCODE and 'z' not in val:
    print('Warning: Template does not appear to support Z-code')

do_release(filename, game, terp_template, web_template, release=opts.release)
