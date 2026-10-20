export DESIGN_NAME = alu32_pipe
export DESIGN_NICKNAME = alu32
export PLATFORM = sky130hd

export VERILOG_FILES = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/src/alu32_pipe.v

export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION = 35
export TNS_END_PERCENT = 100
export PLACE_DENSITY = 0.55
