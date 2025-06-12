class TestRegistry;
    static int configs[string];

    static function void set_int(string key, int value);
        configs[key] = value;
    endfunction

    static function int get_int(string key);
        if (configs.exists(key))
            return configs[key];
        else
            return 0; // default
    endfunction
endclass
