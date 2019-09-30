KPL/MK

Meta-kernel for HERA Dataset v040 -- Studies 20190613_001
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

   This file was created on June 13, 2019 by Marc Costa Sitja ESA/ESAC.


   \begindata

     PATH_VALUES       = ( '../..' )

     PATH_SYMBOLS      = ( 'KERNELS' )

     KERNELS_TO_LOAD   = (

                           '$KERNELS/fk/hera_v03.tf'
                           '$KERNELS/fk/hera_ops_v00.tf'
                           '$KERNELS/fk/hera_sc_didymos_npo_v00.tf'
                           '$KERNELS/fk/hera_dsk_surfaces_v01.tf'

                           '$KERNELS/ik/hera_afc_v02.ti'

                           '$KERNELS/lsk/naif0012.tls'

                           '$KERNELS/pck/pck00010.tpc'
                           '$KERNELS/pck/de-403-masses.tpc'
                           '$KERNELS/pck/hera_didymos_v00.tpc'

                           '$KERNELS/sclk/hera_fict_20181203.tsc'

                           '$KERNELS/spk/de432s.bsp'
                           '$KERNELS/spk/didymos_hor_200101_300101_v01.bsp'
                           '$KERNELS/spk/didymoon_v02.bsp'
                           '$KERNELS/spk/HERA_NomTrajECP_v01.bsp'
                           '$KERNELS/spk/HERA_NomTrajDCP1_v01.bsp'
                           '$KERNELS/spk/HERA_NomTrajDCP3_v01.bsp'
                           '$KERNELS/spk/HERA_NomTrajDCP3VCF_v01.bsp'

                         )

   \begintext


SPICE Kernel Dataset Version
------------------------------------------------------------------------

   The version of this SPICE Kernel Dataset is provided by the following
   keyword:

   \begindata

      SKD_VERSION = 'v040_20190613_001'

   \begintext


Contact Information
------------------------------------------------------------------------

   If you have any questions regarding this file contact SPICE support at
   ESAC:

           Marc Costa Sitja
           (+34) 91-8131-457
           mcosta@sciops.esa.int, esa_spice@sciops.esa.int


   or NAIF at JPL:

           Boris Semenov
           +1 (818) 354-8136
           Boris.Semenov@jpl.nasa.gov


End of MK file.
