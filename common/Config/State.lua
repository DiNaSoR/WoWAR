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
    local resetButton1 = rawget(_G, "WOWTR_ResetButton1")
    if (resetButton1) then
      resetButton1:SetText(WOWTR_Localization.resultButton1);
      local confirmation1 = rawget(_G, "WOWTR_Confirmation1")
      if (confirmation1) then confirmation1:Hide(); end
    end
  else
    QTR_PS = nil;
    BB_PM = nil;
    MF_PM = nil;
    TT_PS = nil;
    BT_PM = nil;
    ST_PM = nil;
    local confirmation2 = rawget(_G, "WOWTR_Confirmation2")
    if (confirmation2) then confirmation2:Hide(); end
  end
  WOWTR_CheckVars();
end

function WOWTR_ReloadUI()
  ReloadUI()
end


