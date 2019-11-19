KPL/FK

Frame (FK) SPICE kernel file for Hera science operations frames
===============================================================================

   This frames kernel defines a number of frames used by the Hera
   science operations centre to perform mission analysis and attitude
   dependent science opportunity identification.

   These frames can be used stand-alone, i.e. referring directly to them and
   assuming they correspond to the Hera spacecraft reference frame, or
   in combination with the Hera spacecraft frames. The latter will allow the
   user to use the existing alignments and instrument frame definitions to
   perform instrument specific mission analysis and attitude dependent
   science opportunity identification. Please refer to the section ``Using
   these frames'' for further details.


Version and Date
-------------------------------------------------------------------------------

   Version 0.0 -- May 22, 2016 -- Marc Costa Sitja, ESAC/ESA

      Initial version.


References
-------------------------------------------------------------------------------

   [1]   "Frames Required Reading"

   [2]   "Kernel Pool Required Reading"


Contact Information
-------------------------------------------------------------------------------

   If you have any questions regarding this file contact SPICE support at
   ESAC:

           Marc Costa Sitja
           (+34) 91-8131-457
           mcosta@sciops.esa.int, esa_spice@sciops.esa.int


Implementation Notes
-------------------------------------------------------------------------------

   This file is used by the SPICE system as follows: programs that make use
   of this frame kernel must "load" the kernel normally during program
   initialization. Loading the kernel associates the data items with
   their names in a data structure called the "kernel pool".  The SPICELIB
   routine FURNSH loads a kernel into the pool as shown below:

     FORTRAN: (SPICELIB)

       CALL FURNSH ( frame_kernel_name )

     C: (CSPICE)

       furnsh_c ( frame_kernel_name );

     IDL: (ICY)

       cspice_furnsh, frame_kernel_name

     MATLAB: (MICE)

       cspice_furnsh ( 'frame_kernel_name' )

     PYTHON: (SPICEYPY)*

       furnsh( frame_kernel_name )

   In order for a program or routine to extract data from the pool, the
   SPICELIB routines GDPOOL, GIPOOL, and GCPOOL are used.  See [2] for
   more details.

   This file was created and may be updated with a text editor or word
   processor.

   * SPICEPY is a non-official, community developed Python wrapper for the
     NAIF SPICE toolkit. Its development is managed on Github.
     It is available at: https://github.com/AndrewAnnex/SpiceyPy


Hera Science Operations frame names and NAIF ID Codes
-------------------------------------------------------------------------------

   The following frame is defined in this kernel file:

      SPICE Frame Name          Long-name
      ------------------------  ---------------------------------------------
      HERA_DIDYMOS_NPO          Hera Didymos Nadir power-optimized pointing


   These frame has the following centers, frame class and NAIF
   ID:

      SPICE Frame Name          Center                 Class     NAIF ID
      ------------------------  ---------------------  -------  ---------
      HERA_DIDYMOS_NPO          HERA                   DYNAMIC   -667010


   The keywords implementing that frame definitions is located in the
   "TGO Science Operations Frame Definitions" section.


General Notes About This File
-------------------------------------------------------------------------------

   About Required Data:
   --------------------
   All the dynamic frames defined in this file require at least one
   of the following kernel types to be loaded prior to their evaluation,
   normally during program initialization:

     - Planetary and Satellite ephemeris data (SPK), i.e. de432, de405, etc;
     - Spacecraft ephemeris data (SPK);

   Note that loading different kernels will lead to different
   orientations of the same frame at a given epoch, providing different
   results from each other, in terms of state vectors referred to these
   frames.


   Using these frames
   ------------------
   These frames have been implemented to define the different pointing
   profiles for the Hera spacecraft. These pointing profiles can be
   used in two different ways:

      [1] ``As is'' for analysis of offsets between the spacecraft
          attitude defined in the corresponding CK and a given pointing
          profile. Loading this kernel in combination with any Hera CK
          will allow the user to perform this comparison between the
          HERA_SPACECRAFT frame and any of the different frames defined
          within this kernel.

      [2] In combination with the Hera Frames kernel, to define
          a default pointing profile for the whole duration of the mission
          together with the spacecraft and instrument frames defined in the
          Hera FK. In this way, instrument-specific mission analysis
          activities, for which a particular pointing profile and knowledge
          of the instruments is required, can be conducted without the need
          for a spacecraft CK.

          In order to define such default pointing profile, the latest
          Hera frames kernel and this file shall be loaded before the
          selected ``Hera spacecraft frame overwrite'' frame kernel. As
          an example, imagine that the desired default pointing profile is
          "Nadir power optimized with respect to Didymos", then the furnish
          (metakernel) file should contain the following sequence of frames
          kernels, in the following order:

              ...

              $DATA/fk/hera_v00.tf
              $DATA/fk/hera_ops_v00.tf
              $DATA/fk/hera_sc_didymos_npo_v00.tf

              ...

            (*) the example presents version 0.0 of the Hera frames
            and Hera Science Operations frames kernels. Newer versions of
            these files will produce the same results.

          By loading the ``hera_sc_didymos_npo_vNN.tf'' frames kernel last,
          the spacecraft frame HERA_SPACECRAFT, which is defined as a CK-based
          frame in the ``Hera frames kernel'', will be overwritten as a
          type-4 fixed offset frame, mapping the HERA_SPACECRAFT frame to
          the HERA_DIDYMOS_NPO frame defined in the ``Hera Science
          Operations Frames Kernel'' (this) file.


Hera Science Operations Frame Definitions
-------------------------------------------------------------------------------

   This section contains the definition of the Hera science operations
   frames.


Hera Mars Nadir power-optimized pointing frame (HERA_DIDYMOS_NPO)
------------------------------------------------------------------------

   Definition:
   -----------
   The Hera Didymos Nadir power-optimized pointing frame is defined as follows
   (from [3]):

      -  -Y axis is the primary vector and points from Hera to the
         center of Didymos (Nadir direction);

      -  -X axis is the secondary vector and is the orthogonal component
         to the -Y axis of the Sun position relative to Hera;

      -  +Z axis completes the right-handed system;

      -  the original of this frame is the spacecraft's center of mass.

   All vectors are geometric: no corrections are used.


   Required Data:
   --------------
   This frame is defined as a two-vector frame.

   Both the primary and the secondary vector are defined as an
   'observer-target position' vectors, therefore, the ephemeris data
   required to compute both the Hera-Didymos position and the Hera-Sun
   position in J2000 frame have to be loaded before using this frame.


   Remarks:
   --------
   Since the primary and secondary vectors of this frame are defined
   based on the Hera-Didymos position and Hera-Sun position vectors, the usage
   of different ephemerides to compute these vectors may lead to different
   frame orientation at given time.

   \begindata

      FRAME_HERA_DIDYMOS_NPO        = -667010
      FRAME_-667010_NAME            = 'HERA_DIDYMOS_NPO'
      FRAME_-667010_CLASS           =  5
      FRAME_-667010_CLASS_ID        = -667010
      FRAME_-667010_CENTER          = -667
      FRAME_-667010_RELATIVE        = 'J2000'
      FRAME_-667010_DEF_STYLE       = 'PARAMETERIZED'
      FRAME_-667010_FAMILY          = 'TWO-VECTOR'
      FRAME_-667010_PRI_AXIS        = 'Z'
      FRAME_-667010_PRI_VECTOR_DEF  = 'OBSERVER_TARGET_POSITION'
      FRAME_-667010_PRI_OBSERVER    = 'HERA'
      FRAME_-667010_PRI_TARGET      = 'DIDYMOS'
      FRAME_-667010_PRI_ABCORR      = 'NONE'
      FRAME_-667010_SEC_AXIS        = 'X'
      FRAME_-667010_SEC_VECTOR_DEF  = 'OBSERVER_TARGET_POSITION'
      FRAME_-667010_SEC_OBSERVER    = 'HERA'
      FRAME_-667010_SEC_TARGET      = 'SUN'
      FRAME_-667010_SEC_ABCORR      = 'NONE'
      FRAME_-667010_SEC_FRAME       = 'J2000'

   \begintext


End of FK file.