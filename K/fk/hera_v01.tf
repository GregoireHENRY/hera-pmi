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

      Asteroid Framing Camera names/IDs:

            HERA_AFC                    -667110
            HERA_AFC_FILTER_1           -667111
            HERA_AFC_FILTER_2           -667102
            HERA_AFC_FILTER_3           -667103
            HERA_AFC_FILTER_4           -667104
            HERA_AFC_FILTER_5           -667105
            HERA_AFC_FILTER_6           -667106
            HERA_AFC_FILTER_7           -667107
            HERA_AFC_FILTER_8           -667108
            HERA_AFC_RAD                -667119


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
      HERA_AFC                  HERA_SPACECRAFT          FIXED        -667110


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

   \begindata

      FRAME_IAU_DIDYMOS                = 2065803000
      FRAME_2065803000_NAME            = 'IAU_DIDYMOS'
      FRAME_2065803000_CLASS           =  5
      FRAME_2065803000_CLASS_ID        = 2065803000
      FRAME_2065803000_CENTER          = 2065803
      FRAME_2065803000_RELATIVE        = 'J2000'
      FRAME_2065803000_DEF_STYLE       = 'PARAMETERIZED'
      FRAME_2065803000_FAMILY          = 'TWO-VECTOR'
      FRAME_2065803000_PRI_AXIS        = 'Z'
      FRAME_2065803000_PRI_VECTOR_DEF  = 'CONSTANT'
      FRAME_2065803000_PRI_FRAME       = 'J2000'
      FRAME_2065803000_PRI_SPEC        = 'LATITUDINAL'
      FRAME_2065803000_PRI_UNITS       = 'DEGREES'
      FRAME_2065803000_PRI_LONGITUDE   = 0
      FRAME_2065803000_PRI_LATITUDE    = 90
      FRAME_2065803000_SEC_AXIS        = 'X'
      FRAME_2065803000_SEC_VECTOR_DEF  = 'OBSERVER_TARGET_VELOCITY'
      FRAME_2065803000_SEC_OBSERVER    = 'DIDYMOS'
      FRAME_2065803000_SEC_TARGET      = 'SUN'
      FRAME_2065803000_SEC_ABCORR      = 'NONE'
      FRAME_2065803000_SEC_FRAME       = 'J2000'

   \begintext


AFC Frames
========================================================================

   This section of the file contains the definitions of the Asteroid Framing
   Camera (AFC) frames.


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
                                 -----------------
                                        |
                                        |<-fixed
                                        |
                                        V
                                    "HERA_AFC"
                                    ----------
                                        |
                                        |<-fixed
                                        |
                                        V
                              "HERA_AFC_FILTER_[1..8]"
                              ------------------------


AFC Frames
--------------------------------------

   The Asteroid Framing Camera frame -- HERA_AFC -- is defined as follows:

      -  +Z axis points along the camera boresight;

      -  +X axis is parallel to the apparent image lines; it is
         nominally co-aligned with the s/c +X axis;

      -  +Y axis completes the right handed frame; it is nominally
         parallel the to the apparent image columns and co-aligned with
         the s/c +Y axis;

      -  the origin of the frame is located at the camera focal point.

   The Framing Cameras filter frames -- HERA_AFC_FILTER_[1..8] -- are
   defined to be nominally co-aligned with the corresponding camera frame.

   This diagram illustrates the AFC camera frames:


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
                          HGA  .'       `.           +Zsc and +Zafc1
                              /___________\           are out of the page
                                  `.|.'


   Nominally, the AFC frames are co-aligned with the s/c frame:

   \begindata

      FRAME_HERA_AFC                   = -667100
      FRAME_-667100_NAME               = 'HERA_AFC'
      FRAME_-667100_CLASS              =  4
      FRAME_-667100_CLASS_ID           = -667100
      FRAME_-667100_CENTER             = -667
      TKFRAME_-667100_RELATIVE         = 'HERA_SPACECRAFT'
      TKFRAME_-667100_SPEC             = 'ANGLES'
      TKFRAME_-667100_UNITS            = 'DEGREES'
      TKFRAME_-667100_ANGLES           = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667100_AXES             = ( 1,   2,   3   )

   \begintext

   The keywords below define the AFC filter frames to be co-aligned with
   the corresponding camera frames.

   \begindata

      FRAME_HERA_AFC_FILTER_1       = -667101
      FRAME_-667101_NAME            = 'HERA_AFC_FILTER_1'
      FRAME_-667101_CLASS           = 4
      FRAME_-667101_CLASS_ID        = -667101
      FRAME_-667101_CENTER          = -667
      TKFRAME_-667101_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667101_SPEC          = 'ANGLES'
      TKFRAME_-667101_UNITS         = 'DEGREES'
      TKFRAME_-667101_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667101_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC_FILTER_2       = -667102
      FRAME_-667102_NAME            = 'HERA_AFC_FILTER_2'
      FRAME_-667102_CLASS           = 4
      FRAME_-667102_CLASS_ID        = -667102
      FRAME_-667102_CENTER          = -667
      TKFRAME_-667102_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667102_SPEC          = 'ANGLES'
      TKFRAME_-667102_UNITS         = 'DEGREES'
      TKFRAME_-667102_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667102_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC_FILTER_3       = -667103
      FRAME_-667103_NAME            = 'HERA_AFC_FILTER_3'
      FRAME_-667103_CLASS           = 4
      FRAME_-667103_CLASS_ID        = -667103
      FRAME_-667103_CENTER          = -667
      TKFRAME_-667103_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667103_SPEC          = 'ANGLES'
      TKFRAME_-667103_UNITS         = 'DEGREES'
      TKFRAME_-667103_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667103_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC_FILTER_4       = -667104
      FRAME_-667104_NAME            = 'HERA_AFC_FILTER_4'
      FRAME_-667104_CLASS           = 4
      FRAME_-667104_CLASS_ID        = -667104
      FRAME_-667104_CENTER          = -667
      TKFRAME_-667104_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667104_SPEC          = 'ANGLES'
      TKFRAME_-667104_UNITS         = 'DEGREES'
      TKFRAME_-667104_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667104_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC_FILTER_5       = -667105
      FRAME_-667105_NAME            = 'HERA_AFC_FILTER_5'
      FRAME_-667105_CLASS           = 4
      FRAME_-667105_CLASS_ID        = -667105
      FRAME_-667105_CENTER          = -667
      TKFRAME_-667105_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667105_SPEC          = 'ANGLES'
      TKFRAME_-667105_UNITS         = 'DEGREES'
      TKFRAME_-667105_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667105_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC_FILTER_6       = -667106
      FRAME_-667106_NAME            = 'HERA_AFC_FILTER_6'
      FRAME_-667106_CLASS           = 4
      FRAME_-667106_CLASS_ID        = -667106
      FRAME_-667106_CENTER          = -667
      TKFRAME_-667106_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667106_SPEC          = 'ANGLES'
      TKFRAME_-667106_UNITS         = 'DEGREES'
      TKFRAME_-667106_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667106_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC_FILTER_7       = -667107
      FRAME_-667107_NAME            = 'HERA_AFC_FILTER_7'
      FRAME_-667107_CLASS           = 4
      FRAME_-667107_CLASS_ID        = -667107
      FRAME_-667107_CENTER          = -667
      TKFRAME_-667107_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667107_SPEC          = 'ANGLES'
      TKFRAME_-667107_UNITS         = 'DEGREES'
      TKFRAME_-667107_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667107_AXES          = ( 1,   2,   3   )

      FRAME_HERA_AFC_FILTER_8       = -667108
      FRAME_-667108_NAME            = 'HERA_AFC_FILTER_8'
      FRAME_-667108_CLASS           = 4
      FRAME_-667108_CLASS_ID        = -667108
      FRAME_-667108_CENTER          = -667
      TKFRAME_-667108_RELATIVE      = 'HERA_AFC'
      TKFRAME_-667108_SPEC          = 'ANGLES'
      TKFRAME_-667108_UNITS         = 'DEGREES'
      TKFRAME_-667108_ANGLES        = ( 0.0, 0.0, 0.0 )
      TKFRAME_-667108_AXES          = ( 1,   2,   3   )

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

    This table summarizes AFC IDs:

      ----------------------  --------
       Name                    ID
      ----------------------  --------
      HERA_AFC                 -667100
      HERA_AFC_FILTER_1        -667101
      HERA_AFC_FILTER_2        -667102
      HERA_AFC_FILTER_3        -667103
      HERA_AFC_FILTER_4        -667104
      HERA_AFC_FILTER_5        -667105
      HERA_AFC_FILTER_6        -667106
      HERA_AFC_FILTER_7        -667107
      HERA_AFC_FILTER_8        -667108
      HERA_AFC_RAD             -667109
      ----------------------  --------

    Name-ID Mapping keywords:

   \begindata

       NAIF_BODY_NAME += ( 'HERA_AFC'                         )
       NAIF_BODY_CODE += ( -667100                            )

       NAIF_BODY_NAME += ( 'HERA_AFC_FILTER_1'                )
       NAIF_BODY_CODE += ( -667101                            )

       NAIF_BODY_NAME += ( 'HERA_AFC_FILTER_2'                )
       NAIF_BODY_CODE += ( -667102                            )

       NAIF_BODY_NAME += ( 'HERA_AFC_FILTER_3'                )
       NAIF_BODY_CODE += ( -667103                            )

       NAIF_BODY_NAME += ( 'HERA_AFC_FILTER_4'                )
       NAIF_BODY_CODE += ( -667104                            )

       NAIF_BODY_NAME += ( 'HERA_AFC_FILTER_5'                )
       NAIF_BODY_CODE += ( -667105                            )

       NAIF_BODY_NAME += ( 'HERA_AFC_FILTER_6'                )
       NAIF_BODY_CODE += ( -667106                            )

       NAIF_BODY_NAME += ( 'HERA_AFC_FILTER_7'                )
       NAIF_BODY_CODE += ( -667107                            )

       NAIF_BODY_NAME += ( 'HERA_AFC_FILTER_8'                )
       NAIF_BODY_CODE += ( -667108                            )

       NAIF_BODY_NAME += ( 'HERA_AFC_RAD'                     )
       NAIF_BODY_CODE += ( -667109                            )

   \begintext


End of FK file.