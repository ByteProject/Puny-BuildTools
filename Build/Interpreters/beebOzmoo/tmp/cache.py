import random

while True:
    while True:
        vmap_local_entries = random.randint(30, 90)
        vmap_cache_entries = random.randint(0, 200)
        vmap_total_entries = vmap_local_entries + vmap_cache_entries
        if vmap_total_entries <= 255:
            break

    # vmap here doesn't simulate the "low" bits containing address. Note that
    # the same timestamp can appear more than once.
    vmap = [x // 2 for x in range(255)]
    random.shuffle(vmap)
    vmap = vmap[0:vmap_total_entries]
    original_vmap = vmap[:]

    # cutover is supplied by build script in reality, to avoid doing this
    # sort in Ozmoo code.
    sorted_vmap = sorted(vmap, reverse=True)
    # This out-of-bounds condition can't really occur in the real code; this is
    # being done in the loader, the full vmap size is 255 entries and the local
    # entries is never going to be that high (absolutely still-not-possible max
    # is 128 as we only have 64K RAM on the second processor). vmap_cache_entries
    # just might be 0 at runtime, so we want to test that, but this specific logic
    # is just for this test.
    if vmap_cache_entries > 0:
        cutover = sorted_vmap[vmap_local_entries]
    else:
        cutover = 0
    sorted_vmap = None # stop accidental use

    cache = []
    from_index = 0
    to_index = 0

    while to_index < vmap_local_entries:
        vmap[to_index] = vmap[from_index]
        # load_blocks_from_index(to_index)
        if vmap[to_index] <= cutover and len(cache) < vmap_cache_entries:
            assert vmap[to_index] in original_vmap
            cache.append(vmap[to_index])
        else:
            to_index += 1
        from_index += 1

    last_index = vmap_local_entries - 1
    while from_index < vmap_total_entries:
        assert vmap[last_index] in original_vmap
        cache.append(vmap[last_index])
        assert len(cache) <= vmap_cache_entries
        vmap[last_index] = vmap[from_index]
        # load_blocks_from_index(last_index)
        from_index += 1

    print
    print("cache", sorted(cache))
    local_vmap = vmap[0:vmap_local_entries]
    print("local vmap", sorted(local_vmap))


    assert len(cache) <= vmap_cache_entries
    assert len(local_vmap) + len(cache) == len(original_vmap)
    assert sorted(local_vmap + cache) == sorted(original_vmap)

    cache_sorted = sorted(cache)
    local_vmap_sorted = sorted(local_vmap)
    out_of_order = []
    while len(cache_sorted) > 0 and cache_sorted[-1] > local_vmap_sorted[0]:
        out_of_order.extend([cache_sorted[-1], local_vmap_sorted[0]])
        cache_sorted = cache_sorted[:-1]
        local_vmap_sorted = local_vmap_sorted[1:]
    if len(out_of_order) > 0:
        print("out of order", out_of_order)
    assert len(out_of_order) <= 2
