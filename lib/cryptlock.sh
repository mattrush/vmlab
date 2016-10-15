#!/bin/bash

cryptlock () {
  # restrict action by run state
  [ -n "$runflag" ] && echo "Guest is running. Halt first" && return 1	


}
