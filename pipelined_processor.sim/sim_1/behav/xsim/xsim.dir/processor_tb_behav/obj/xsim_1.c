/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_2(char*, char *);
extern void execute_133(char*, char *);
extern void execute_138(char*, char *);
extern void vlog_simple_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_140(char*, char *);
extern void execute_141(char*, char *);
extern void execute_142(char*, char *);
extern void execute_197(char*, char *);
extern void execute_198(char*, char *);
extern void execute_199(char*, char *);
extern void execute_200(char*, char *);
extern void execute_201(char*, char *);
extern void execute_202(char*, char *);
extern void execute_203(char*, char *);
extern void execute_204(char*, char *);
extern void execute_205(char*, char *);
extern void execute_206(char*, char *);
extern void execute_207(char*, char *);
extern void execute_208(char*, char *);
extern void execute_209(char*, char *);
extern void execute_210(char*, char *);
extern void execute_211(char*, char *);
extern void execute_212(char*, char *);
extern void execute_213(char*, char *);
extern void execute_214(char*, char *);
extern void execute_215(char*, char *);
extern void execute_216(char*, char *);
extern void execute_217(char*, char *);
extern void execute_218(char*, char *);
extern void execute_219(char*, char *);
extern void execute_220(char*, char *);
extern void execute_221(char*, char *);
extern void execute_222(char*, char *);
extern void execute_223(char*, char *);
extern void execute_224(char*, char *);
extern void execute_225(char*, char *);
extern void execute_226(char*, char *);
extern void execute_227(char*, char *);
extern void execute_228(char*, char *);
extern void execute_229(char*, char *);
extern void execute_230(char*, char *);
extern void execute_231(char*, char *);
extern void execute_232(char*, char *);
extern void execute_233(char*, char *);
extern void execute_234(char*, char *);
extern void execute_235(char*, char *);
extern void execute_236(char*, char *);
extern void execute_237(char*, char *);
extern void execute_238(char*, char *);
extern void execute_239(char*, char *);
extern void execute_240(char*, char *);
extern void execute_241(char*, char *);
extern void execute_147(char*, char *);
extern void execute_148(char*, char *);
extern void execute_149(char*, char *);
extern void execute_150(char*, char *);
extern void execute_151(char*, char *);
extern void execute_152(char*, char *);
extern void execute_153(char*, char *);
extern void execute_154(char*, char *);
extern void execute_155(char*, char *);
extern void execute_156(char*, char *);
extern void execute_157(char*, char *);
extern void execute_158(char*, char *);
extern void execute_5(char*, char *);
extern void execute_7(char*, char *);
extern void execute_8(char*, char *);
extern void execute_10(char*, char *);
extern void execute_11(char*, char *);
extern void execute_16(char*, char *);
extern void execute_17(char*, char *);
extern void execute_19(char*, char *);
extern void execute_21(char*, char *);
extern void execute_22(char*, char *);
extern void execute_159(char*, char *);
extern void execute_160(char*, char *);
extern void execute_26(char*, char *);
extern void execute_27(char*, char *);
extern void execute_28(char*, char *);
extern void execute_161(char*, char *);
extern void execute_162(char*, char *);
extern void execute_30(char*, char *);
extern void execute_31(char*, char *);
extern void execute_33(char*, char *);
extern void execute_34(char*, char *);
extern void execute_39(char*, char *);
extern void execute_40(char*, char *);
extern void execute_41(char*, char *);
extern void execute_42(char*, char *);
extern void execute_43(char*, char *);
extern void execute_166(char*, char *);
extern void execute_167(char*, char *);
extern void execute_168(char*, char *);
extern void execute_45(char*, char *);
extern void execute_65(char*, char *);
extern void execute_66(char*, char *);
extern void execute_80(char*, char *);
extern void execute_81(char*, char *);
extern void execute_113(char*, char *);
extern void execute_114(char*, char *);
extern void execute_190(char*, char *);
extern void execute_135(char*, char *);
extern void execute_136(char*, char *);
extern void execute_137(char*, char *);
extern void execute_242(char*, char *);
extern void execute_243(char*, char *);
extern void execute_244(char*, char *);
extern void execute_245(char*, char *);
extern void execute_246(char*, char *);
extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_53(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_54(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_55(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_88(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_100(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_105(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[116] = {(funcp)execute_2, (funcp)execute_133, (funcp)execute_138, (funcp)vlog_simple_process_execute_0_fast_no_reg_no_agg, (funcp)execute_140, (funcp)execute_141, (funcp)execute_142, (funcp)execute_197, (funcp)execute_198, (funcp)execute_199, (funcp)execute_200, (funcp)execute_201, (funcp)execute_202, (funcp)execute_203, (funcp)execute_204, (funcp)execute_205, (funcp)execute_206, (funcp)execute_207, (funcp)execute_208, (funcp)execute_209, (funcp)execute_210, (funcp)execute_211, (funcp)execute_212, (funcp)execute_213, (funcp)execute_214, (funcp)execute_215, (funcp)execute_216, (funcp)execute_217, (funcp)execute_218, (funcp)execute_219, (funcp)execute_220, (funcp)execute_221, (funcp)execute_222, (funcp)execute_223, (funcp)execute_224, (funcp)execute_225, (funcp)execute_226, (funcp)execute_227, (funcp)execute_228, (funcp)execute_229, (funcp)execute_230, (funcp)execute_231, (funcp)execute_232, (funcp)execute_233, (funcp)execute_234, (funcp)execute_235, (funcp)execute_236, (funcp)execute_237, (funcp)execute_238, (funcp)execute_239, (funcp)execute_240, (funcp)execute_241, (funcp)execute_147, (funcp)execute_148, (funcp)execute_149, (funcp)execute_150, (funcp)execute_151, (funcp)execute_152, (funcp)execute_153, (funcp)execute_154, (funcp)execute_155, (funcp)execute_156, (funcp)execute_157, (funcp)execute_158, (funcp)execute_5, (funcp)execute_7, (funcp)execute_8, (funcp)execute_10, (funcp)execute_11, (funcp)execute_16, (funcp)execute_17, (funcp)execute_19, (funcp)execute_21, (funcp)execute_22, (funcp)execute_159, (funcp)execute_160, (funcp)execute_26, (funcp)execute_27, (funcp)execute_28, (funcp)execute_161, (funcp)execute_162, (funcp)execute_30, (funcp)execute_31, (funcp)execute_33, (funcp)execute_34, (funcp)execute_39, (funcp)execute_40, (funcp)execute_41, (funcp)execute_42, (funcp)execute_43, (funcp)execute_166, (funcp)execute_167, (funcp)execute_168, (funcp)execute_45, (funcp)execute_65, (funcp)execute_66, (funcp)execute_80, (funcp)execute_81, (funcp)execute_113, (funcp)execute_114, (funcp)execute_190, (funcp)execute_135, (funcp)execute_136, (funcp)execute_137, (funcp)execute_242, (funcp)execute_243, (funcp)execute_244, (funcp)execute_245, (funcp)execute_246, (funcp)vlog_transfunc_eventcallback, (funcp)transaction_53, (funcp)transaction_54, (funcp)transaction_55, (funcp)transaction_88, (funcp)transaction_100, (funcp)transaction_105};
const int NumRelocateId= 116;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/processor_tb_behav/xsim.reloc",  (void **)funcTab, 116);

	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/processor_tb_behav/xsim.reloc");
}

void simulate(char *dp)
{
	iki_schedule_processes_at_time_zero(dp, "xsim.dir/processor_tb_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern void implicit_HDL_SCinstatiate();

extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/processor_tb_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/processor_tb_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/processor_tb_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
