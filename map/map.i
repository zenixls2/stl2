%module map
%include <std_common.i>
%include <std_pair.i>

%{
#include <map>
#include <algorithm>
#include <stdexcept>
#include <utility>
#include <iterator>
#include <utility>
#include <iostream>
#include <__tree>
%}

%inline %{
namespace std {
    template<typename A, typename AA, typename B>
    class _map_iterator {
        B _iter;
    public:
        _map_iterator(B iter): _iter(iter) {}
        A getValue() {
            return (A)((*_iter).second);
        }
        AA getKey() {
            return (AA)((*_iter).first);
        }
        _map_iterator* next() {
            _iter++;
            return this;
        }
        _map_iterator* prev() {
            _iter--;
            return this;
        }
    };
};
%}
namespace std {

template <class _Key, class _Tp>
struct __value_type {
    pair<const _Key, _Tp> __cc;
};
template <class _TreeIterator>
class __map_iterator {
public:
    __map_iterator();
    __map_iterator(_TreeIterator _i);
    %extend {
        std::pair<
            typename std::__extract_key_value_types<
                _TreeIterator::value_type>::__key_type,
            typename std::__extract_key_value_types<
                _TreeIterator::value_type>::__mapped_type>& get() const {
            return (*self).operator*();
        }
        std::__extract_key_value_types<_TreeIterator::value_type>::__mapped_type&
        getValue() const {
            return (*self)->second;
        }
        std::__extract_key_value_types<_TreeIterator::value_type>::__key_type&
        getKey() const {
            return (*self)->first;
        }
    }
};
template<class K, class T, class Compare=std::less<K>, 
         class Allocator=std::allocator<pair<const K, T> > >
class map {
public:
    typedef size_t size_type;
    typedef ptrdiff_t difference_type;
    typedef K key_type;
    typedef T mapped_type;
    typedef pair<const key_type, mapped_type> value_type;
    typedef Compare key_compare;
    typedef std::__tree<std::__value_type<K, T>,
        std::__map_value_compare<K,std::__value_type<K, T>,Compare>,
        typename std::__rebind_alloc_helper<
            std::allocator_traits<Allocator>,
            __value_type<K, T>
            >::type
        > __base;
    typedef __map_iterator<typename __base::iterator> iterator;
    typedef __map_iterator<typename __base::const_iterator> const_iterator;
    map();
    map(const map<K, T, Compare> &);
    unsigned int size() const;
    size_type max_size() const;
    bool empty() const;
    void clear();
    void swap(map& other);
    size_t erase(const K& key);
    const T& at(const K& key) const;
    size_t count(const K& key) const;
    iterator find(const K& key);
    iterator lower_bound(const K& key);
    iterator upper_bound(const K& key);
    std::pair<map<K, T, Compare>::iterator,
         map<K, T, Compare>::iterator> equal_range(const K& key);
    %extend {
        const T& get(const K& key) throw (std::out_of_range) {
            auto i = self->find(key);
            if (i != self->end())
                return i->second;
            else
                throw std::out_of_range("key not found");
        }
        void set(const K& key, const T& x) {
            (*self)[key] = x;
        }
        void del(const K& key) throw (std::out_of_range) {
            auto i = self->find(key);
            if (i != self->end())
                self->erase(i);
            else
                throw std::out_of_range("key not found");
        }
        bool has_key(const K& key) {
            return self->find(key) != self->end();
        }
    }
};

%define MAP_BASE(K, V)
    typename std::__tree<
    std::__value_type<K, V>,
    std::__map_value_compare<K, std::__value_type<K, V>, std::less<K> >,
    typename std::__rebind_alloc_helper<
        std::allocator_traits<std::allocator<std::pair<const K, V> > >,
        std::__value_type<K, V>
    >::type>
%enddef
%define MAP_DEFINE(K, V)
    %template(Iter_ ## K ##_ ## V) _map_iterator<##K, ##V, __map_iterator<MAP_BASE(##K, ##V)::iterator> >;
    %template(_Map_ ## K ##_ ## V) map<##K, ##V>;
%insert(go_wrapper) %{
type Map_ ## K ## _ ## V interface {
    X_Map_ ## K ##_ ## V
    LowerBound(## K) (Iter_ ## K ##_ ## V)
    UpperBound(## K) (Iter_ ## K ##_ ## V)
}
func (arg SwigcptrX_Map_ ## K ##_ ## V) LowerBound(key K) (Iter_##K##_##V) {
    return NewIter_##K##_##V(arg.Lower_bound(key))
}
func (arg SwigcptrX_Map_ ## K ##_ ## V) UpperBound(key K) (Iter_##K##_##V) {
    return NewIter_##K##_##V(arg.Upper_bound(key))
}
func NewMap_##K##_##V(a ...interface{}) (Map_##K##_##V) {
    argc := len(a)
    if argc == 0 {
        return NewX_Map_##K##_##V().(Map_##K##_##V)
    }
    if argc == 1 {
        return NewX_Map_##K##_##V(a).(Map_##K##_##V)
    }
    panic("No match for overloaded function call")
}
func DeleteMap_##K##_##V(arg Map_##K##_##V) {
    DeleteX_Map_##K##_##V(arg.(X_Map_##K##_##V))
}
%}
%enddef
}
