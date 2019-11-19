KPL/MK

Meta-kernel for HERA Dataset v050 -- Studies 20190909_001
==========================================================================

   This meta-kernel lists the hera Studies SPICE kernels
   that provide information for the Studies scenario.

   The kernels listed in this meta-kernel and the order in which
   they are listed are picked to provide the best data available and
   the most complete coverage for the hera Studies scenario.


Usage of the Meta-kernel
-------------------------------------------------------------------------

   This file is used by the SPICE system as follows: programs that make use
   of this kernel must "load" the kernel normally during program
   initialization. Loading the kernel associates the data items with
   their names in a data structure called the "kernel pool". The SPICELIB
   routine FURNSH loads a kernel into the pool.

   The kernels listed below can be obtained from the ESA SPICE FTP server:

      ftp://spiftp.esac.esa.int/data/SPICE/hera/kernels/


Implementation Notes
-------------------------------------------------------------------------

   It is recommended that users make a local copy of this file and
   modify the value of the PATH_VALUES keyword to point to the actual
   location of the hera SPICE data set's ``data'' directory on
   their system. Replacing ``/'' with ``\'' and converting line
   terminators to the format native to the user's system may also be
   required if this meta-kernel is to be used on a non-UNIX workstation.


-------------------

   This file was created on September 9, 2019 by Marc Costa Sitja ESA/ESAC.


   \begindata

     PATH_VALUES       = ( '../..' )

     PATH_SYMBOLS      = ( 'KERNELS' )

     KERNELS_TO_LOAD   = (

                           '$KERNELS/fk/hera_v04.tf'
                           '$KERNELS/fk/hera_ops_v01.tf'
                           '$KERNELS/fk/hera_sc_didymain_npo_v01.tf'
                           '$KERNELS/fk/hera_dsk_surfaces_v02.tf'

                           '$KERNELS/ik/hera_afc_v03.ti'
                           '$KERNELS/ik/hera_palt_v00.ti'
                           '$KERNELS/ik/hera_tira_v00.ti'

                           '$KERNELS/lsk/naif0010.tls'

                           '$KERNELS/pck/pck00010.tpc'
                           '$KERNELS/pck/de-403-masses.tpc'
                           '$KERNELS/pck/hera_didymos_v01.tpc'

                           '$KERNELS/sclk/hera_fict_20181203.tsc'

                           '$KERNELS/spk/de432s.bsp'
                           '$KERNELS/spk/didymos_hor_200101_300101_v01.bsp'
                           '$KERNELS/spk/HERA_sc_DCP1_v01.bsp'
                           '$KERNELS/spk/HERA_didymain_DCP1_v01.bsp'
                           '$KERNELS/spk/HERA_didymoon_DCP1_v01.bsp'
                           '$KERNELS/spk/HERA_sc_DCP3_v01.bsp'
                           '$KERNELS/spk/HERA_didymain_DCP3_v01.bsp'
                           '$KERNELS/spk/HERA_didymoon_DCP3_v01.bsp'
                           '$KERNELS/spk/HERA_sc_DCP3VCF_v01.bsp'
                           '$KERNELS/spk/HERA_didymoon_DCP3VCF_v01.bsp'
                           '$KERNELS/spk/HERA_didymain_DCP3VCF_v01.bsp'
                           '$KERNELS/spk/HERA_sc_ECP_v01.bsp'
                           '$KERNELS/spk/HERA_didymain_ECP_v01.bsp'
                           '$KERNELS/spk/HERA_didymoon_ECP_v01.bsp'

                           '$KERNELS/dsk/hera_didymoon_k001_v02.bds'
                           '$KERNELS/dsk/hera_didymain_k001_v01.bds'

                         )

   \begintext


SPICE Kernel Dataset Version
------------------------------------------------------------------------

   The version of this SPICE Kernel Dataset is provided by the following
   keyword:

   \begindata

      SKD_VERSION = 'v050_20190909_001'

   \begintext


Contact Information
------------------------------------------------------------------------

   If you have any questions regarding this file contact SPICE support at
   ESAC:

           Marc Costa Sitja
           (+34) 91-8131-457
           marc.costa@esa.int, esa_spice@sciops.esa.int


End of MK file.
