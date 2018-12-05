%% EffectivenessCheck
function Effe = EffectivenessCheck(sorted, solu)

inv_solu = fliplr(solu);
diff_inv = sum(abs(inv_solu-solu));
diff_sor = sum(abs(sorted-solu));
Effe = diff_sor/ diff_inv;

end