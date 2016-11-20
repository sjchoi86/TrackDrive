function saverlist = add2saverlist(saverlist, saver, othercars)

saverlist.n = saverlist.n + 1;
saverlist.savers{saverlist.n} = saver;
saverlist.othercars{saverlist.n} = othercars;
