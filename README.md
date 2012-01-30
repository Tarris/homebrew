This branch contains my modified formulas to build gtk (and stuff dependend on gtk) with the quartz backend. No more X11 windows :)

To compile gtk etc. with quartz support just pass --quartz to the brew command, e.g.

brew install gtk+ --quartz

The formulas are tested (to some extend) on a Snow Leopard 64bit machine and may or may not work for others. Feel free to use, modify and comment them.

Kathrin
