function ang = cspice_angvec2(targ1, targ2, et, frame, corr, obs)

[r1, ~] = cspice_spkpos(targ1, et, frame, corr, obs);
[r2, ~] = cspice_spkpos(targ2, et, frame, corr, obs);

ang = angvec2(r1, r2);