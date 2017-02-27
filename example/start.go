package main

import (
	"fmt"
	stl "github.com/zenixls2/stl2/example/stl"
)

func main() {
	mapi := stl.NewMap_int_int()
	mapi.Set(1, 1)
	mapi.Set(2, 2)
	mapi.Set(3, 4)
	fmt.Println(mapi.Get(1))
	iter := stl.NewIter_int_int(mapi.Lower_bound(2))
	fmt.Println(iter.GetKey(), iter.GetValue())
	iter.Next()
	fmt.Println(iter.GetKey(), iter.GetValue())
	stl.DeleteMap_int_int(mapi)
}
