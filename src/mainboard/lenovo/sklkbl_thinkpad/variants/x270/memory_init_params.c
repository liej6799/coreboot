/* SPDX-License-Identifier: GPL-2.0-only */

#include <soc/romstage.h>
#include <spd_bin.h>

void mainboard_memory_init_params(FSPM_UPD *mupd)
{
	FSP_M_CONFIG *mem_cfg = &mupd->FspmConfig;
	mem_cfg->DqPinsInterleaved = false;			/* DDR_DQ probably not in interleave mode */
	mem_cfg->CaVrefConfig      = 1;				/* VREF_CA to CH_A */
	mem_cfg->MemorySpdDataLen  = CONFIG_DIMM_SPD_SIZE;

	/* Get SPD for memory slots */
	struct spd_block blk = { .addr_map = { 0x50 } };
	get_spd_smbus(&blk);
	dump_spd_info(&blk);

	mem_cfg->MemorySpdPtr00    = (uintptr_t)blk.spd_array[0];
}
