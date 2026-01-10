-- Config state utilities: reset saved variables and reload
-------------------------------------------------------------------------------------------------------

function WOWTR_ResetVariables(nr)
  if (nr == 1) then
    QTR_SAVED = nil;
    QTR_MISSING = nil;
    QTR_GOSSIP = nil;
    BB_PS = nil;
    BB_TR = nil;
    MF_PS = nil;
    TT_TUTORIALS = nil;
    BT_SAVED = nil;
    ST_PS = nil;
    ST_PH = nil;
    if (WOWTR_ResetButton1) then
      WOWTR_ResetButton1:SetText(WoWTR_Localization.resultButton1);
      if (WOWTR_Confirmation1) then WOWTR_Confirmation1:Hide(); end
    end
  else
    QTR_PS = nil;
    BB_PM = nil;
    MF_PM = nil;
    TT_PS = nil;
    BT_PM = nil;
    ST_PM = nil;
    if (WOWTR_Confirmation2) then WOWTR_Confirmation2:Hide(); end
  end
  WOWTR_CheckVars();
end

function WOWTR_ReloadUI()
  ReloadUI()
end


