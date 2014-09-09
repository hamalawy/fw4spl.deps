# Locate CAMP library
# This module defines
#  CAMP_FOUND, if false, do not try to link to CAMP
#  CAMP_LIBRARIES
#  CAMP_INCLUDE_DIR, where to find camp/version.hpp

find_path(CAMP_INCLUDE_DIR camp/version.hpp
  HINTS
  $ENV{CAMP_DIR}
  PATH_SUFFIXES include
  PATHS
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Tegesoft\\CAMP]
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw # Fink
  /opt/local # DarwinPorts
  /opt/csw # Blastwave
  /opt
)

find_library(CAMP_LIBRARY 
  NAMES camp campd
  HINTS
  $ENV{CAMP_DIR}
  PATH_SUFFIXES lib64 lib
  PATHS
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Tegesoft\\CAMP]
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw
  /opt/local
  /opt/csw
  /opt
)

set(CAMP_LIBRARIES "${CAMP_LIBRARY}" CACHE STRING "CAMP Libraries")

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set CAMP_FOUND to TRUE if 
# all listed variables are TRUE
FIND_PACKAGE_HANDLE_STANDARD_ARGS(CAMP DEFAULT_MSG CAMP_LIBRARIES CAMP_INCLUDE_DIR)

MARK_AS_ADVANCED(CAMP_INCLUDE_DIR CAMP_LIBRARIES CAMP_LIBRARY)

