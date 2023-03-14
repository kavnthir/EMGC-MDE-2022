# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "clk_100_Hz" -parent ${Page_0}
  ipgui::add_param $IPINST -name "clk_DAC_Hz" -parent ${Page_0}
  ipgui::add_param $IPINST -name "clk_RS422_Hz" -parent ${Page_0}
  ipgui::add_param $IPINST -name "clk_timer_Hz" -parent ${Page_0}
  ipgui::add_param $IPINST -name "input_Hz" -parent ${Page_0}


}

proc update_PARAM_VALUE.clk_100_Hz { PARAM_VALUE.clk_100_Hz } {
	# Procedure called to update clk_100_Hz when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.clk_100_Hz { PARAM_VALUE.clk_100_Hz } {
	# Procedure called to validate clk_100_Hz
	return true
}

proc update_PARAM_VALUE.clk_DAC_Hz { PARAM_VALUE.clk_DAC_Hz } {
	# Procedure called to update clk_DAC_Hz when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.clk_DAC_Hz { PARAM_VALUE.clk_DAC_Hz } {
	# Procedure called to validate clk_DAC_Hz
	return true
}

proc update_PARAM_VALUE.clk_RS422_Hz { PARAM_VALUE.clk_RS422_Hz } {
	# Procedure called to update clk_RS422_Hz when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.clk_RS422_Hz { PARAM_VALUE.clk_RS422_Hz } {
	# Procedure called to validate clk_RS422_Hz
	return true
}

proc update_PARAM_VALUE.clk_timer_Hz { PARAM_VALUE.clk_timer_Hz } {
	# Procedure called to update clk_timer_Hz when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.clk_timer_Hz { PARAM_VALUE.clk_timer_Hz } {
	# Procedure called to validate clk_timer_Hz
	return true
}

proc update_PARAM_VALUE.input_Hz { PARAM_VALUE.input_Hz } {
	# Procedure called to update input_Hz when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.input_Hz { PARAM_VALUE.input_Hz } {
	# Procedure called to validate input_Hz
	return true
}


proc update_MODELPARAM_VALUE.input_Hz { MODELPARAM_VALUE.input_Hz PARAM_VALUE.input_Hz } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.input_Hz}] ${MODELPARAM_VALUE.input_Hz}
}

proc update_MODELPARAM_VALUE.clk_100_Hz { MODELPARAM_VALUE.clk_100_Hz PARAM_VALUE.clk_100_Hz } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.clk_100_Hz}] ${MODELPARAM_VALUE.clk_100_Hz}
}

proc update_MODELPARAM_VALUE.clk_timer_Hz { MODELPARAM_VALUE.clk_timer_Hz PARAM_VALUE.clk_timer_Hz } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.clk_timer_Hz}] ${MODELPARAM_VALUE.clk_timer_Hz}
}

proc update_MODELPARAM_VALUE.clk_RS422_Hz { MODELPARAM_VALUE.clk_RS422_Hz PARAM_VALUE.clk_RS422_Hz } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.clk_RS422_Hz}] ${MODELPARAM_VALUE.clk_RS422_Hz}
}

proc update_MODELPARAM_VALUE.clk_DAC_Hz { MODELPARAM_VALUE.clk_DAC_Hz PARAM_VALUE.clk_DAC_Hz } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.clk_DAC_Hz}] ${MODELPARAM_VALUE.clk_DAC_Hz}
}

