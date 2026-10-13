/* SPDX-License-Identifier: GPL-2.0-only */

/*
 * Lid state notification for the integrated graphics driver, following
 * the vendor firmware's SaSsdt implementation (methods VLOC/GNOT/PDRD
 * operating on the Intel OpRegion mailbox).
 */
#if CONFIG(H8_HAS_GFX_LID_NOTIFY)
Scope (\_SB.PCI0.GFX0)
{
	OperationRegion (GLPC, PCI_Config, 0x00, 0x100)
	Field (GLPC, DWordAcc, NoLock, Preserve)
	{
		Offset (0xFC),
		GLAS, 32
	}

	OperationRegion (GLMM, SystemMemory, GLAS, 0x2000)
	Field (GLMM, DWordAcc, NoLock, Preserve)
	{
		Offset (0x100),
		DRDY, 32,
		CSTS, 32,
		CEVT, 32,
		Offset (0x1AC),
		ASLP, 32,
		TIDX, 32,
		CHPD, 32,
		CLID, 32
	}

	/* Driver ready */
	Method (PDRD, 0, NotSerialized)
	{
		Return (!DRDY)
	}

	/* Graphics notification */
	Method (GNOT, 2, NotSerialized)
	{
		If (PDRD ())
		{
			Return (One)
		}

		CEVT = Arg0
		CSTS = 0x03
		If ((CHPD == Zero) && (Arg1 == Zero))
		{
			Notify (\_SB.PCI0.GFX0, Zero)
		}

		Notify (\_SB.PCI0.GFX0, 0x80)
		Return (Zero)
	}

	/*
	 * Lid state change notification.
	 * Arg0: 0 lid closed, 1 lid open
	 */
	Method (VLOC, 1, NotSerialized)
	{
		If (Arg0 == \_SB.PCI0.LPCB.EC.LID._LID ())
		{
			CLID = Arg0
			GNOT (0x02, Zero)
		}
	}
}
#endif
