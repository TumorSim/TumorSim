#julia -i scripts/launch_dashboard.jl
using DrWatson
@quickactivate "TumorSim"
using TumorSim
using DataFrames
using Blink
@eval AtomShell begin
    function init(; debug = false)
        electron() # Check path exists
        p, dp = port(), port()
        debug && inspector(dp)
        dbg = debug ? "--debug=$dp" : []
        proc = (debug ? run_rdr : run)(
            `$(electron()) --no-sandbox $dbg $mainjs port $p`; wait=false)
        conn = try_connect(ip"127.0.0.1", p)
        shell = Electron(proc, conn)
        initcbs(shell)
        return shell
    end
end
launch_dashboard()
