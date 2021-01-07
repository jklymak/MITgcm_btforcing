C $Header$
C $Name$

#include "BTFORCING_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
C !ROUTINE: MYPACKAGE_READPARMS

C !INTERFACE:
      SUBROUTINE MYPACKAGE_READPARMS( myThid )

C     !DESCRIPTION:
C     Initialize MYPACKAGE variables and constants.

C     !USES:
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "BTFORCING.h"

C     !INPUT PARAMETERS:
      INTEGER myThid
CEOP

#ifdef ALLOW_MYPACKAGE

C     !LOCAL VARIABLES:
C     msgBuf     :: Informational/error message buffer
C     iUnit      :: Work variable for IO unit number
      CHARACTER*(MAX_LEN_MBUF) msgBuf
      INTEGER iUnit

      NAMELIST /BTFORCING_PARM01/
     &       btforcingTideAmp, btforcingTideFreq, btforcingU0

      IF ( .NOT.useBTFORCING ) THEN
C-    pkg MYPACKAGE is not used
        _BEGIN_MASTER(myThid)
C-    Track pkg activation status:
C     print a (weak) warning if data.mypackage is found
         CALL PACKAGES_UNUSED_MSG( 'useBTFORCING', ' ', ' ' )
        _END_MASTER(myThid)
        RETURN
      ENDIF

      _BEGIN_MASTER(myThid)

C--   Default values for MYPACKAGE
      btforcingTideFreq=0.00014053
      btforcingTideAmp=0.0
      btforcingU0=0.0


      WRITE(msgBuf,'(A)') 'BTFORCING_READPARMS: opening data.btforcing'
      CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                    SQUEEZE_RIGHT , 1)
      CALL OPEN_COPY_DATA_FILE(
     I                     'data.btforcing', 'BTFORCING_READPARMS',
     O                     iUnit,
     I                     myThid )

C     Read parameters from open data file
      READ(UNIT=iUnit,NML=BTFORCING_PARM01)
      WRITE(msgBuf,'(A)')
     &    'BTFORCING_READPARMS: finished reading data.btforcing'
      CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &    SQUEEZE_RIGHT , 1)
C     Close the open data file
      CLOSE(iUnit,STATUS='DELETE')

      _END_MASTER(myThid)

C--   Everyone else must wait for the parameters to be loaded
      _BARRIER

#endif /* ALLOW_MYPACKAGE */

      RETURN
      END
