KPL/FK

Hera Spacecraft Frames Kernel
=============================================================================

   This frame kernel contains complete set of frame definitions for the
   Hera (named after the Greek goddess of marriage) including definitions
   for the Hera fixed and Hera science instrument frames. This kernel
   also contains NAIF ID/name mapping for the Hera science instruments
   and s/c structures (see the last section of the file).


Version and Date
-----------------------------------------------------------------------------

   Version 0.2 -- January 22, 2019 -- Marc Costa Sitja, ESAC/ESA

      Added AFC-2 on top of AFC.

   Version 0.1 -- December 3, 2018 -- Marc Costa Sitja, ESAC/ESA

      Added Frame Camera IDs, reference frames and enhanced outline.

   Version 0.0 -- September 21, 2018 -- Marc Costa Sitja, ESAC/ESA

      Preliminary Version. Only basic ID and frame definitions.


References
-----------------------------------------------------------------------------

   1.   ``Frames Required Reading''

   2.   ``Kernel Pool Required Reading''

   3.   ``C-Kernel Required Reading''


Contact Information
-----------------------------------------------------------------------------

   If you have any questions regarding this file contact the ESA SPICE
   Service at ESAC:

           Marc Costa Sitja
           (+34) 91-8131-457
           mcosta@sciops.esa.int, esa_spice@sciops.esa.int


Implementation Notes
-----------------------------------------------------------------------------

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


Hera Mission NAIF ID Codes
-----------------------------------------------------------------------------

   The following names and NAIF ID codes are assigned to the Hera spacecraft,
   its structures and science instruments (the keywords implementing these
   definitions are located in the section "Hera Mission NAIF ID
   Codes -- Definition Section" at the end of this file):

      Hera Spacecraft and Spacecraft Structures names/IDs:

            HERA                        -667

            HERA_SPACECRAFT             -667000  (synonym: HERA_SC)

      Asteroid Framing Cameras 1 and 2 names/IDs:

            HERA_AFC-1                  -667110
            HERA_AFC-1_FILTER_1         -667111
            HERA_AFC-1_FILTER_2         -667112
            HERA_AFC-1_FILTER_3         -667113
            HERA_AFC-1_FILTER_4         -667114
            HERA_AFC-1_FILTER_5         -667115
            HERA_AFC-1_FILTER_6         -667116
            HERA_AFC-1_FILTER_7         -667117
            HERA_AFC-1_FILTER_8         -667118

            HERA_AFC-2                  -667120
            HERA_AFC-2_FILTER_1         -667121
            HERA_AFC-2_FILTER_2         -667122
            HERA_AFC-2_FILTER_3         -667123
            HERA_AFC-2_FILTER_4         -667124
            HERA_AFC-2_FILTER_5         -667125
            HERA_AFC-2_FILTER_6         -667126
            HERA_AFC-2_FILTER_7         -667127
            HERA_AFC-2_FILTER_8         -667128

            HERA_AFC_RAD                -667109


Hera Mission Frames
-----------------------------------------------------------------------------

   The following Hera frames are defined in this kernel file:

           Name                  Relative to               Type       NAIF ID
      ======================  ========================  ==========   =========

    Spacecraft frames:
    ------------------
      HERA_SPACECRAFT           J2000                    CK           -667000

    Asteroid Framing Camera Frames:
    -------------------------------
      HERA_AFC-1                HERA_SPACECRAFT          FIXED        -667110
      HERA_AFC-2                HERA_SPACECRAFT          FIXED        -667120


   In addition, the following frames, in use by the BepiColombo mission, are
   defined in other kernels or `built into' the SPICE system:


  Hera mission specific science frame:
   -------------------------------------------
      HERA_DEFAULT              J2000                  DYNAMIC       -667010
      IAU_DIDYMOS               J2000                  DYNAMIC    2065803000


   SPICE 'Built-in' PCK frames in use by BepiColombo (3):
   ------------------------------------------------------
      IAU_EARTH                J2000                     PCK        built-in

      (3) Data for these frames is loaded using either the PCK file
          "pckVVVVV.tpc" (VVVVV is the version number)


Hera Frames Hierarchy
-----------------------------------------------------------------------------

  The diagram below shows the Hera spacecraft and its structures frame
  hierarchy (not including science instrument frames.)

                                 "J2000" INERTIAL
           +-----------------------------------------------------+
           |                            |                        |
           |<-pck                       |                        |<-dynamic
           |                            |                        |
           V                            |                        V
      "EARTH_FIXED"                     |                  "IAU_DYDIMOS"
      -------------                     |                  -------------
                                        |
                                        |<-ck
                                        |
                                        V
                                 "HERA_SPACECRAFT"
                                 -----------------
                                        .
                                        .
                                        .
                                        .
                                        V
                   Individual instrument frame trees are provided
                     in the corresponding sections of this file


Hera Spacecraft and Spacecraft Structures Frames
========================================================================

   This section of the file contains the definitions of the spacecraft
   and spacecraft structures frames.


Hera Spacecraft Frame
--------------------------------------

   The Hera spacecraft frame is defined as follows:

      -  +Z axis is along the nominal boresight direction of the asteroid
         framing camera;

      -  +X axis is along the nominal boresight direction of the HGA;

      -  +Y axis completes the right-hand frame;

      -  the origin of this frame is the launch vehicle interface point.

   These diagrams illustrate the HERA_SPACECRAFT frame:


   +X s/c side (HGA side) view:
   ----------------------------
                                    ^
                                    | toward asteroid
                                    |

                               Science Deck
                             ._____________.
   .__  _______________.     |   ._____.   |     .______________  ___.
   |  \ \               \    | .'       `. |    /               \ \  |
   |  / /                \   |/     |     \|   /                / /  |
   |  \ \                 `. .      |      . .'                 \ \  |
   |  / /                 | o|      o      |o |                 / /  |
   |  \ \                 .' .    .' `.    . `.                 \ \  |
   |  / /                /   |\ +Zsc^  `  /|   \                / /  |
   .__\ \_______________/    | `.   |   .' |    \_______________\ \__.
     -Y Solar Array          .___` -|- '___.       +Y Solar Array
                                  / | \
                                  `-o-----> +Ysc
                                  +Xsc
                                                     +Xsc is out of
                                                        the page

   +Z s/c side (science deck side) view:
   -------------------------------------

                             ._____________.
                             |             |
                             |             |
                             |  +Zsc    +Ysc
   o==/ /==================o |      o----->|o==================/ /==o
     -Y Solar Array          |      |      |        +Y Solar Array
                             |      |      |
                             .______|______.
                                 .--V +Xsc
                          HGA  .'       `.
                              /___________\
                                  `.|.'                 +Zsc is out
                                                       of the page


   Since the orientation of the HERA_SPACECRAFT frame is computed
   on-board, sent down in telemetry, and stored in the s/c CK files, it
   is defined as a CK-based frame.

   \begindata

      FRAME_HERA_SPACECRAFT            = -667000
      FRAME_-667000_NAME               = 'HERA_SPACECRAFT'
      FRAME_-667000_CLASS              =  3
      FRAME_-667000_CLASS_ID           = -667000
      FRAME_-667000_CENTER             = -667
      CK_-667000_SCLK                  = -667
      CK_-667000_SPK                   = -667

   \begintext


AFC Frames
========================================================================

   This section of the file contains the definitions of the Asteroid Framing
   Cameras (AFC-1 and AFC-2) frames.


AFC Frame Tree
--------------------------------------

   The diagram below shows the AFC frame hierarchy.

                                 "J2000" INERTIAL
           +-----------------------------------------------------+
           |                            |                        |
           |<-pck                       |                        |<-dynamic
           |                            |                        |
           V                            |                        V
      "EARTH_FIXED"                     |                  "IAU_DYDIMOS"
      -------------                     |                  -------------
                                        |
                                        |<-ck
                                        |
                                        V
                                "HERA_SPACECRAFT"
                             +---------------------+
                             |                     |
                             |<-fixed              |<-fixed
                             |                     |
                             V                     V
                         "HERA_AFC-1"          "HERA_AFC-2"
                         -----------            -----------
                             |                     |
                             |<-fixed              |<-fixed
                             |                     |
                             V                     V
                "HERA_AFC-1_FILTER_[1..8]"   "HERA_AFC-2_FILTER_[1..8]"
                --------------------------   --------------------------


AFC Frames
--------------------------------------

   The Asteroid Framing Camera frames -- HERA_AFC-1 and HERA_AFC-2 --
   are defined as follows:

      -  +Z axis points along the camera boresight;

      -  +X axis is parallel to the apparent image lines; it is
         nominally co-aligned with the s/c +X axis;

      -  +Y axis completes the right handed frame; it is nominally
         parallel the to the apparent image columns and co-aligned with
         the s/c +Y axis;

      -  the origin of the frame is located at the camera focal point.

   The Framing Cameras filter frames -- HERA_AFC-[1,2]_FILTER_[1..8] -- are
   defined to be nominally co-aligned with the corresponding camera frame.

   This diagram illustrates the AFC-1 and AFC-2 camera frames:


   +Z s/c side (science deck side) view:
   -------------------------------------

                             ._____________.
                             |    o-------> +Yafc
                             |    |        |
                             |    |        |+Ysc
   o==/ /==================o |    | o----->|o==================/ /==o
     -Y Solar Array          |    V |      |        +Y Solar Array
                             |+Xafc |
                             .______|______.
                                 .--V +Xsc
                          HGA  .'       `.           +Zsc and +Zafc
                              /___________\           are out of the page
                                  `.|.'


   Nominally, the AFC frames are co-aligned with the s/c frame:

   \begindata

      FRAME_HERA_AFC-1                 = -667110
      FRAME_-667110_NAME               = 'HERA_AFC-1'
      FRAME_-667110_CLASS              =  4
      FRAME_-667110_CLASS_ID           = -667110
      FRAME_-667110_CENTER             = -667
      TKFRAME_-667110_RELATIVE         = 'HERA_SPACECRAFT'
      TKFRAME_-667110_SPEC             = 'ANGLES'
      TKFRAME_-667110_UNITS            = 'DEGREES'
      TKFRAME_-667110_ANGLES           = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667110_AXES             = ( 1,   2,   3   )

      FRAME_HERA_AFC-2                 = -667120
      FRAME_-667120_NAME               = 'HERA_AFC-2'
      FRAME_-667120_CLASS              =  4
      FRAME_-667120_CLASS_ID           = -667120
      FRAME_-667120_CENTER             = -667
      TKFRAME_-667120_RELATIVE         = 'HERA_SPACECRAFT'
      TKFRAME_-667120_SPEC             = 'ANGLES'
      TKFRAME_-667120_UNITS            = 'DEGREES'
      TKFRAME_-667120_ANGLES           = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667120_AXES             = ( 1,   2,   3   )

   \begintext

   The keywords below define the AFC filter frames to be co-aligned with
   the corresponding camera frames.

   \begindata

      FRAME_HERA_AFC-1_FILTER_1     = -667111
      FRAME_-667111_NAME            = 'HERA_AFC-1_FILTER_1'
      FRAME_-667111_CLASS           = 4
      FRAME_-667111_CLASS_ID        = -667111
      FRAME_-667111_CENTER          = -667
      TKFRAME_-667111_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667111_SPEC          = 'ANGLES'
      TKFRAME_-667111_UNITS         = 'DEGREES'
      TKFRAME_-667111_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667111_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC-1_FILTER_2     = -667112
      FRAME_-667112_NAME            = 'HERA_AFC-1_FILTER_2'
      FRAME_-667112_CLASS           = 4
      FRAME_-667112_CLASS_ID        = -667112
      FRAME_-667112_CENTER          = -667
      TKFRAME_-667112_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667112_SPEC          = 'ANGLES'
      TKFRAME_-667112_UNITS         = 'DEGREES'
      TKFRAME_-667112_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667112_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC-1_FILTER_3     = -667113
      FRAME_-667113_NAME            = 'HERA_AFC-1_FILTER_3'
      FRAME_-667113_CLASS           = 4
      FRAME_-667113_CLASS_ID        = -667113
      FRAME_-667113_CENTER          = -667
      TKFRAME_-667113_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667113_SPEC          = 'ANGLES'
      TKFRAME_-667113_UNITS         = 'DEGREES'
      TKFRAME_-667113_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667113_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC-1_FILTER_4     = -667114
      FRAME_-667114_NAME            = 'HERA_AFC-1_FILTER_4'
      FRAME_-667114_CLASS           = 4
      FRAME_-667114_CLASS_ID        = -667114
      FRAME_-667114_CENTER          = -667
      TKFRAME_-667114_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667114_SPEC          = 'ANGLES'
      TKFRAME_-667114_UNITS         = 'DEGREES'
      TKFRAME_-667114_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667114_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC-1_FILTER_5     = -667115
      FRAME_-667115_NAME            = 'HERA_AFC-1_FILTER_5'
      FRAME_-667115_CLASS           = 4
      FRAME_-667115_CLASS_ID        = -667115
      FRAME_-667115_CENTER          = -667
      TKFRAME_-667115_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667115_SPEC          = 'ANGLES'
      TKFRAME_-667115_UNITS         = 'DEGREES'
      TKFRAME_-667115_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667115_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC-1_FILTER_6     = -667116
      FRAME_-667116_NAME            = 'HERA_AFC-1_FILTER_6'
      FRAME_-667116_CLASS           = 4
      FRAME_-667116_CLASS_ID        = -667116
      FRAME_-667116_CENTER          = -667
      TKFRAME_-667116_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667116_SPEC          = 'ANGLES'
      TKFRAME_-667116_UNITS         = 'DEGREES'
      TKFRAME_-667116_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667116_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC-1_FILTER_7     = -667117
      FRAME_-667117_NAME            = 'HERA_AFC-1_FILTER_7'
      FRAME_-667117_CLASS           = 4
      FRAME_-667117_CLASS_ID        = -667117
      FRAME_-667117_CENTER          = -667
      TKFRAME_-667117_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667117_SPEC          = 'ANGLES'
      TKFRAME_-667117_UNITS         = 'DEGREES'
      TKFRAME_-667117_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667117_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC-1_FILTER_8     = -667118
      FRAME_-667118_NAME            = 'HERA_AFC-1_FILTER_8'
      FRAME_-667118_CLASS           = 4
      FRAME_-667118_CLASS_ID        = -667118
      FRAME_-667118_CENTER          = -667
      TKFRAME_-667118_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667118_SPEC          = 'ANGLES'
      TKFRAME_-667118_UNITS         = 'DEGREES'
      TKFRAME_-667118_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667118_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC-2_FILTER_1     = -667121
      FRAME_-667121_NAME            = 'HERA_AFC-2_FILTER_1'
      FRAME_-667121_CLASS           = 4
      FRAME_-667121_CLASS_ID        = -667121
      FRAME_-667121_CENTER          = -667
      TKFRAME_-667121_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667121_SPEC          = 'ANGLES'
      TKFRAME_-667121_UNITS         = 'DEGREES'
      TKFRAME_-667121_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667121_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC-1_FILTER_2     = -667122
      FRAME_-667122_NAME            = 'HERA_AFC-2_FILTER_2'
      FRAME_-667122_CLASS           = 4
      FRAME_-667122_CLASS_ID        = -667122
      FRAME_-667122_CENTER          = -667
      TKFRAME_-667122_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667122_SPEC          = 'ANGLES'
      TKFRAME_-667122_UNITS         = 'DEGREES'
      TKFRAME_-667122_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667122_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC-1_FILTER_3     = -667123
      FRAME_-667123_NAME            = 'HERA_AFC-2_FILTER_3'
      FRAME_-667123_CLASS           = 4
      FRAME_-667123_CLASS_ID        = -667123
      FRAME_-667123_CENTER          = -667
      TKFRAME_-667123_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667123_SPEC          = 'ANGLES'
      TKFRAME_-667123_UNITS         = 'DEGREES'
      TKFRAME_-667123_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667123_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC-1_FILTER_4     = -667124
      FRAME_-667124_NAME            = 'HERA_AFC-2_FILTER_4'
      FRAME_-667124_CLASS           = 4
      FRAME_-667124_CLASS_ID        = -667124
      FRAME_-667124_CENTER          = -667
      TKFRAME_-667124_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667124_SPEC          = 'ANGLES'
      TKFRAME_-667124_UNITS         = 'DEGREES'
      TKFRAME_-667124_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667124_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC-1_FILTER_5     = -667125
      FRAME_-667125_NAME            = 'HERA_AFC-2_FILTER_5'
      FRAME_-667125_CLASS           = 4
      FRAME_-667125_CLASS_ID        = -667125
      FRAME_-667125_CENTER          = -667
      TKFRAME_-667125_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667125_SPEC          = 'ANGLES'
      TKFRAME_-667125_UNITS         = 'DEGREES'
      TKFRAME_-667125_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667125_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC-1_FILTER_6     = -667126
      FRAME_-667126_NAME            = 'HERA_AFC-2_FILTER_6'
      FRAME_-667126_CLASS           = 4
      FRAME_-667126_CLASS_ID        = -667126
      FRAME_-667126_CENTER          = -667
      TKFRAME_-667126_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667126_SPEC          = 'ANGLES'
      TKFRAME_-667126_UNITS         = 'DEGREES'
      TKFRAME_-667126_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667126_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC-1_FILTER_7     = -667127
      FRAME_-667127_NAME            = 'HERA_AFC-2_FILTER_7'
      FRAME_-667127_CLASS           = 4
      FRAME_-667127_CLASS_ID        = -667127
      FRAME_-667127_CENTER          = -667
      TKFRAME_-667127_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667127_SPEC          = 'ANGLES'
      TKFRAME_-667127_UNITS         = 'DEGREES'
      TKFRAME_-667127_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667127_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC-1_FILTER_8     = -667128
      FRAME_-667128_NAME            = 'HERA_AFC-2_FILTER_8'
      FRAME_-667128_CLASS           = 4
      FRAME_-667128_CLASS_ID        = -667128
      FRAME_-667128_CENTER          = -667
      TKFRAME_-667128_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667128_SPEC          = 'ANGLES'
      TKFRAME_-667128_UNITS         = 'DEGREES'
      TKFRAME_-667128_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667128_AXES          = ( 1,   2,   3   )

   \begintext


Hera NAIF ID Codes to Name Mapping
------------------------------------------------------------------------------

   This section contains name to NAIF ID mappings for the BepiColombo MPO
   mission. Once the contents of this file is loaded into the KERNEL POOL,
   these mappings become available within SPICE, making it possible to use
   names instead of ID code in the high level SPICE routine calls.

  Spacecraft:
  ----------------------------------------------------------------

      This table presents the Hera Spacecraft and its main
      structures' names.

      ---------------------  -------  --------------------------
       Name                   ID       Synonyms
      ---------------------  -------  --------------------------
       HERA                     -121
       HERA_SPACECRAFT       -121000   HERA_SC
       DIDYMOS               2065803
      ---------------------  -------  --------------------------

      Notes:

         -- 'HERA_SC' and 'HERA_SPACECRAFT' are synonyms and all map to the
            Hera s/c bus structure ID (-667000);

     \begindata

        NAIF_BODY_NAME += ( 'HERA'                            )
        NAIF_BODY_CODE += ( -667                              )

        NAIF_BODY_NAME += ( 'HERA_SC'                         )
        NAIF_BODY_CODE += ( -667000                           )

        NAIF_BODY_NAME += ( 'HERA_SPACECRAFT'                 )
        NAIF_BODY_CODE += ( -667000                           )

        NAIF_BODY_NAME += ( 'DIDYMOS'                         )
        NAIF_BODY_CODE += ( 2065803                           )

     \begintext


  AFC:
  ----

    This table summarizes AFCs IDs:

      ----------------------  --------
       Name                    ID
      ----------------------  --------
      HERA_AF-1                -667110
      HERA_AFC-1_FILTER_1      -667111
      HERA_AFC-1_FILTER_2      -667112
      HERA_AFC-1_FILTER_3      -667113
      HERA_AFC-1_FILTER_4      -667114
      HERA_AFC-1_FILTER_5      -667115
      HERA_AFC-1_FILTER_6      -667116
      HERA_AFC-1_FILTER_7      -667117
      HERA_AFC-1_FILTER_8      -667118

      HERA_AF-2                -667120
      HERA_AFC-2_FILTER_1      -667121
      HERA_AFC-2_FILTER_2      -667122
      HERA_AFC-2_FILTER_3      -667123
      HERA_AFC-2_FILTER_4      -667124
      HERA_AFC-2_FILTER_5      -667125
      HERA_AFC-2_FILTER_6      -667126
      HERA_AFC-2_FILTER_7      -667127
      HERA_AFC-2_FILTER_8      -667128

      HERA_AFC_RAD             -667109
      ----------------------  --------

    Name-ID Mapping keywords:

   \begindata

       NAIF_BODY_NAME += ( 'HERA_AFC-1'                       )
       NAIF_BODY_CODE += ( -667110                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-1_FILTER_1'              )
       NAIF_BODY_CODE += ( -667111                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-1_FILTER_2'              )
       NAIF_BODY_CODE += ( -667112                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-1_FILTER_3'              )
       NAIF_BODY_CODE += ( -667113                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-1_FILTER_4'              )
       NAIF_BODY_CODE += ( -667114                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-1_FILTER_5'              )
       NAIF_BODY_CODE += ( -667115                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-1_FILTER_6'              )
       NAIF_BODY_CODE += ( -667116                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-1_FILTER_7'              )
       NAIF_BODY_CODE += ( -667117                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-1_FILTER_8'              )
       NAIF_BODY_CODE += ( -667118                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-2'                       )
       NAIF_BODY_CODE += ( -667120                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-2_FILTER_1'              )
       NAIF_BODY_CODE += ( -667121                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-2_FILTER_2'              )
       NAIF_BODY_CODE += ( -667122                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-2_FILTER_3'              )
       NAIF_BODY_CODE += ( -667123                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-2_FILTER_4'              )
       NAIF_BODY_CODE += ( -667124                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-2_FILTER_5'              )
       NAIF_BODY_CODE += ( -667125                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-2_FILTER_6'              )
       NAIF_BODY_CODE += ( -667126                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-2_FILTER_7'              )
       NAIF_BODY_CODE += ( -667127                            )

       NAIF_BODY_NAME += ( 'HERA_AFC-2_FILTER_8'              )
       NAIF_BODY_CODE += ( -667128                            )

       NAIF_BODY_NAME += ( 'HERA_AFC_RAD'                     )
       NAIF_BODY_CODE += ( -667109                            )

   \begintext


End of FK file.