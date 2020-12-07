:- initialization(main).

main :-
    is_help -> print_help;
    profetch_version(Version) -> write(Version), nl;
    uname(Uname), hostname(Host),
    distro(Distro), kernel(Kernel), 
    uptime(Uptime), loadavrg(Loadavrg),
    ushell(Shell), terminal(Term),
    mem(Mem), swap(Swap),
    editor(Ed), web_browser(Web),
    fmt('username     ', Uname),
    fmt('hostname     ', Host),
    fmt('distro       ', Distro),
    fmt('kernel       ', Kernel),
    fmt('uptime       ', Uptime),
    fmt('load average ', Loadavrg),
    fmt('shell        ', Shell),
    fmt('terminal     ', Term),
    fmt('memory       ', Mem),
    fmt('swap         ', Swap),
    fmt('editor       ', Ed),
    fmt('web browser  ', Web),
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
    open('/etc/os-release', read, Stream),
    distro_search(Stream, Distro),
    close(Stream);
    idk(Distro).

distro_search(Stream, Distro) :-
    repeat, (read_token(Stream, var('ID')) -> read_token(Stream, _), read_token(Stream, Distro), ! ; fail).

kernel(Kernel) :-
    os_version(Kernel);
    idk(Kernel).

uptime(Uptime) :-
    open('/proc/uptime', read, Stream), read_number(Stream, Seconds), close(Stream),
    Hours is floor(Seconds / 3600),
    Minutes is floor((Seconds / 60) - (Hours * 60)),
    open_output_atom_stream(String),
    format(String, '~dh ~dm', [Hours, Minutes]),
    close_output_atom_stream(String, Uptime);
    idk(Uptime).

loadavrg(Loadavrg) :-
    open('/proc/loadavg', read, Stream),
    read_number(Stream, A), read_number(Stream, B), read_number(Stream, C),
    close(Stream),
    open_output_atom_stream(String),
    format(String, '~2f ~2f ~2f', [A, B, C]),
    close_output_atom_stream(String, Loadavrg);
    idk(Loadavrg).

ushell(Shell) :-
    environ('SHELL', Shell);
    idk(Shell).

terminal(Term) :-
    environ('TERM', Term);
    idk(Term).

mem(Mem) :-
    open('/proc/meminfo', read, StreamA), memtotal_search(StreamA, MemTotalInKb), close(StreamA),
    open('/proc/meminfo', read, StreamB), memavailable_search(StreamB, MemAvailable), close(StreamB),
    MemUsed is floor((MemTotalInKb - MemAvailable) / 1024),
    MemTotal is floor(MemTotalInKb / 1024),
    open_output_atom_stream(String),
    format(String, '~d MB / ~d MB', [MemUsed, MemTotal]),
    close_output_atom_stream(String, Mem);
    idk(Mem).

memtotal_search(Stream, MemTotal) :-
    repeat, (read_token(Stream, var('MemTotal')) -> read_token(Stream, _), read_token(Stream, MemTotal), ! ; fail).

memavailable_search(Stream, MemAvailable) :-
    repeat, (read_token(Stream, var('MemAvailable')) -> read_token(Stream, _), read_token(Stream, MemAvailable), ! ; fail).

swap(Swap) :-
    open('/proc/meminfo', read, StreamA), swaptotal_search(StreamA, SwapTotalInKb), close(StreamA),
    open('/proc/meminfo', read, StreamB), swapfree_search(StreamB, SwapFree), close(StreamB),
    open_output_atom_stream(String),
    SwapUsed is floor((SwapTotalInKb - SwapFree) / 1024),
    SwapTotal is floor(SwapTotalInKb / 1024),
    format(String, '~d MB / ~d MB', [SwapUsed, SwapTotal]),
    close_output_atom_stream(String, Swap);
    idk(Swap).

swaptotal_search(Stream, SwapTotal) :-
    repeat, (read_token(Stream, var('SwapTotal')) -> read_token(Stream, _), read_token(Stream, SwapTotal), ! ; fail).

swapfree_search(Stream, SwapFree) :-
    repeat, (read_token(Stream, var('SwapFree')) -> read_token(Stream, _), read_token(Stream, SwapFree), ! ; fail).

editor(Editor) :-
    environ('EDITOR', Editor);
    environ('VISUAL', Editor);
    idk(Editor).

web_browser(Web) :-
    environ('BROWSER', Web);
    idk(Web).

is_help :-
    argument_list(Argv),
    memberchk('--help', Argv).

profetch_version(Version) :-
    argument_list(Argv),
    memberchk('--version', Argv),
    Version = 'v0.1.5'.

print_help :-
    argument_value(0, ProgName),
    format('Usage: ~a [OPTIONS...]', [ProgName]), nl,
    write('OPTIONS:'), nl,
    write('    --help        print this message'), nl,
    write('    --version     print profetch version'), nl.
