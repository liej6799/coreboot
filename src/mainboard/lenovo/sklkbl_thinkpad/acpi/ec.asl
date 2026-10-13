/* SPDX-License-Identifier: GPL-2.0-only */

#define BRIGHTNESS_UP \_SB.PCI0.GFX0.INCB
#define BRIGHTNESS_DOWN \_SB.PCI0.GFX0.DECB
#define THINKPAD_EC_GPE 22

#if CONFIG(BOARD_LENOVO_X270)
/* Match the vendor AML's ten one-second battery initialization retries. */
#define BATTERY_INITIALIZATION_RETRIES 10
#endif

Name(\TCRT, 100)
Name(\TPSV, 90)
Name(\FLVL, 0)

#include <ec/lenovo/h8/acpi/ec.asl>
#if CONFIG(BOARD_LENOVO_X270)
#include <ec/lenovo/h8/acpi/thinkpad_bat_thresholds_24.asl>
#elif CONFIG(H8_HAS_BAT_THRESHOLDS_IMPL)
#include <ec/lenovo/h8/acpi/thinkpad_bat_thresholds_b0.asl>
#endif
