/* SPDX-License-Identifier: GPL-2.0-only */

#include <build.h>
#include <smbios.h>
#include <soc/ramstage.h>
#include <string.h>
#include "variant.h"

#if CONFIG(BOARD_LENOVO_X270)
const char *smbios_mainboard_bios_version(void)
{
	/* Use the coreboot ThinkPad identifier recognized by thinkpad_acpi. */
	if (strlen(CONFIG_LOCALVERSION))
		return "CBET4000 " CONFIG_LOCALVERSION;

	return "CBET4000 " COREBOOT_VERSION;
}

const char *smbios_mainboard_version(void)
{
	return "ThinkPad " CONFIG_MAINBOARD_PART_NUMBER;
}
#endif

void mainboard_silicon_init_params(FSP_SIL_UPD *params)
{
	// Setup GPIOs
	variant_config_gpios();
}

static void mainboard_enable(struct device *dev)
{
	if (CONFIG(VARIANT_HAS_DGPU))
		dgpu_detect();
}

struct chip_operations mainboard_ops = {
	.enable_dev = mainboard_enable,
};
