:- initialization(main).

main :-
    uname(Uname), hostname(Host),
    distro(Distro), kernel(Kernel), 
    uptime(Uptime), loadavrg(Loadavrg),
    ushell(Shell), terminal(Term),
    mem(Mem), swap(Swap),
    editor(Ed), web_browser(Web),
    fmt('     username', Uname),
    fmt('     hostname', Host),
    fmt('       distro', Distro),
    fmt('       kernel', Kernel),
    fmt('       uptime', Uptime),
    fmt(' load average', Loadavrg),
    fmt('        shell', Shell),
    fmt('     terminal', Term),
    fmt('       memory', Mem),
    fmt('         swap', Swap),
    fmt('       editor', Ed),
    fmt('  web browser', Web),
    halt.

fmt(Text, Info) :-
    put_code(0x1b), write('[1;34m'),
    write(Text), write(' ~ '),
    put_code(0x1b), write('[m'),
    write(Info), nl.

idk(X) :-
    read_token_from_atom('\'unknown :(\'', X).

uname(Name) :-
    environ('USER', Name);
    idk(Name).

hostname(Host) :-
    host_name(Host);
    idk(Host).

distro(Distro) :-
    popen('echo "\'$(grep ^ID= /etc/os-release)\'"', read, Sin),
    read_atom(Sin, DistroWithID),
    sub_atom(DistroWithID, 3, _, 0, Distro);
    idk(Distro).

kernel(Kernel) :-
    os_version(Kernel);
    idk(Kernel).

uptime(Uptime) :-
    open('/proc/uptime', read, Sin), read_number(Sin, Sec), close(Sin),
    Hours is floor(Sec / 3600),
    Minuts is floor((Sec / 60) - (Hours * 60)),
    open_output_atom_stream(S),
    format(S, '~dh ~dm', [Hours, Minuts]),
    close_output_atom_stream(S, Uptime);
    idk(Uptime).

loadavrg(Loadavrg) :-
    open('/proc/loadavg', read, Sin), read_number(Sin, A), read_number(Sin, B), read_number(Sin, C), close(Sin),
    open_output_atom_stream(S),
    format(S, '~2f ~2f ~2f', [A, B, C]),
    close_output_atom_stream(S, Loadavrg);
    idk(Loadavrg).

ushell(Shell) :-
    environ('SHELL', Shell);
    idk(Shell).

terminal(Term) :-
    environ('TERM', Term);
    idk(Term).

mem(Mem) :-
    popen('grep ^MemTotal /proc/meminfo | awk \'{print $2}\'', read, Sin), read_integer(Sin, MemTotal),
    popen('grep ^MemAvailable /proc/meminfo | awk \'{print $2}\'', read, Sinn), read_integer(Sinn, MemAvailable),
    open_output_atom_stream(S),
    MemTaken is floor((MemTotal - MemAvailable) / 1024),
    MemT is floor(MemTotal / 1024),
    format(S, '~d MB / ~d MB', [MemTaken, MemT]),
    close_output_atom_stream(S, Mem);
    idk(Mem).

swap(Swap) :-
    popen('grep ^SwapTotal /proc/meminfo | awk \'{print $2}\'', read, Sin), read_integer(Sin, SwapTotal),
    popen('grep ^SwapFree /proc/meminfo | awk \'{print $2}\'', read, Sinn), read_integer(Sinn, SwapFree),
    open_output_atom_stream(S),
    SwapTaken is floor((SwapTotal - SwapFree) / 1024),
    SwapT is floor(SwapTotal / 1024),
    format(S, '~d MB / ~d MB', [SwapTaken, SwapT]),
    close_output_atom_stream(S, Swap);
    idk(Swap).

editor(Editor) :-
    environ('EDITOR', Editor);
    environ('VISUAL', Editor);
    idk(Editor).

web_browser(Web) :-
    environ('BROWSER', Web);
    idk(Web).
