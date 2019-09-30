function et = setup_et(mode, arg)

if strcmp(mode, 'init dur')
    t0 = arg{1};
    dur = arg{2};
    et = [t0 t0+dur];
elseif strcmp(mode, 'init dur fill')
    t0 = arg{1};
    dur = arg{2};
    if (numel(arg) < 3)
        step = 1;
    else
        step = arg{3};
    end
    et = t0:step:t0+dur;
elseif strcmp(mode, 'utc dur')
    utc = arg{1};
    dur = arg{2};
    t0 = cspice_str2et(utc);
    et = [t0 t0+dur];
elseif strcmp(mode, 'utc dur fill')
    utc = arg{1};
    dur = arg{2};
    t0 = cspice_str2et(utc);
    if (numel(arg) < 3)
        step = 1;
    else
        step = arg{3};
    end
    et = t0:step:t0+dur;
elseif strcmp(mode, 'utc')
    utc1 = arg{1};
    utc2 = arg{2};
    et = cspice_str2et({utc1 utc2});
elseif strcmp(mode, 'utc fill')
    utc1 = arg{1};
    utc2 = arg{2};
    if (numel(arg) < 3)
        step = 1;
    else
        step = arg{3};
    end
    et_bounds = cspice_str2et({utc1 utc2});
    et = et_bounds(1):step:et_bounds(2);
elseif strcmp(mode, 'utc single')
    utc1 = arg{1};
    et = cspice_str2et(utc1);
else
    et = NaN;
end
