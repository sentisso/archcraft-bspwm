-- set the offset from the center of the window by X
function conky_offsetc(X, right)
    local center = math.floor(conky_window.width / 2) + X
    local cmd = ""
    if right then
        cmd = "${alignr}"
        center = center * -1
    end
    cmd = cmd.."${offset "..center.."}"
    return conky_parse(cmd)
end

nvidia = nil
function conky_get_gpu_name()
    if nvidia == nil then
        local fd = io.popen("nvidia-smi --query-gpu=gpu_name --format=csv,noheader")
        nvidia = fd:read("*all"):gsub("\n", "")

        rc = {fd:close()}
        if rc[3] ~= 0 then
            nvidia = ""
        end
    end

    if nvidia ~= "" then
        return nvidia
    end

    return "AMD ATI Radeon Vega Mobile Series"
end

resolution = nil
function conky_get_resolution()
    if resolution == nil then
        local fd = io.popen("xdpyinfo | awk '/dimensions/{print $2}'")
        resolution = fd:read("*all"):gsub("\n", "")

        rc = {fd:close()}
        if rc[3] ~= 0 then
            resolution = "unknown"
        end
    end

    return resolution
end

lang = nil
function conky_get_lang()
    if lang == nil then
        local fd = io.popen("cat /etc/default/locale | grep LANG= | cut -d= -f2")
        lang = fd:read("*all"):gsub("\n", "")
        fd:close()
    end

    return lang
end

network_connection = nil
function conky_get_connected_network_device()
    if not network_connection == nil then
        return network_connection
    end

    -- Get the device with state "connected" and the connection profile's name
    local fd = io.popen("nmcli -t -f DEVICE,STATE,CONNECTION device | grep ':connected'")
    local result = fd:read("*all")
    fd:close()

    -- Extract the relevant details for wlan0 and enp0s25
    local wlan_device, wlan_state, wlan_connection = result:match("(wlan0):([^:]+):([^:\n]+)")
    local eth_device, eth_state, eth_connection = result:match("(enp0s25):([^:]+):([^:\n]+)")

    if wlan_state == "connected" then
        network_connection = string.format("WiFi connected: %s", wlan_connection)
    elseif eth_state == "connected" then
        network_connection = string.format("Ethernet connected: %s", eth_connection)
    else
        network_connection = "Disconnected"
        connected_network_device = nil
    end

    return network_connection
end

cpu_name = nil
function conky_get_cpu_name()
    if cpu_name == nil then
        local fd = io.popen("cat /proc/cpuinfo | grep 'model name' | uniq | sed -e 's/model name.*: //'")
        cpu_name = fd:read("*all"):gsub("\n", "")
        fd:close()
    end

    return cpu_name
end