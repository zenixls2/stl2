# STL2 golang binding
This package extends swig implementation on c++ stl by supporting iterator
and other c++11/14 features. The build flow should be a little bit different.

### Development
You can look into example folder for the use case.
Some macors are introduced to perform template engine like features.
Notice that you have to write your own swig interface to use these macros:

```swig
%include <main.i>

namespace std {
  MAP_DEFINE(int, int)
};
```

Currently since swig doesn't support multiple paths for SWIG\_LIB, 
You have to manually write a Makefile to add -I option for swig build flow.