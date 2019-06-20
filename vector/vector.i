%module vector
%include <std_common.i>

%{
#include <vector>
#include <stdexcept>
%}
namespace std {
template <class T, class Allocator=std::allocator<T> >
class vector {
public:
    typedef size_t size_type;
    typedef T value_type;
    typedef const value_type& const_reference;
    typedef Allocator allocator_type;
    vector();
    vector(size_type n);
    vector(const vector& v);
    size_type size() const;
    size_type capacity() const;
    void reserve(size_type n);
    %rename(isEmpty) empty;
    bool empty() const;
    void clear();
    %rename(add) push_back;
    void push_back(const value_type& x);
    %extend {
        const_reference get(size_t i) throw (std::out_of_range) {
            if (i >= 0 && i < self->size())
                return (*self)[i];
            else
                throw std::out_of_range("vector index out of range");
        }
        void set(size_t i, const value_type& val) throw (std::out_of_range) {
            if (i >= 0 && i < self->size())
                (*self)[i] = val;
            else
                throw std::out_of_range("vector index out of range");
        }
    }
};
template<class Allocator = std::allocator<T> >
class vector<bool, Allocator> {
public:
    typedef size_t size_type;
    typedef bool value_type;
    typedef bool const_reference;
    vector();
    vector(size_type n);
    size_type size() const;
    size_type capacity() const;
    void reserve(size_type n);
    %rename(isEmpty) empty;
    bool empty() const;
    void clear();
    %rename(add) push_back;
    void push_back(const value_type& x);
    %extend {
        bool get(size_t i) throw (std::out_of_range) {
            if (i >= 0 && i < self->size())
                return (*self)[i];
            else
                throw std::out_of_range("vector index out of range");
        }
        void set(size_t i, const value_type& val) throw (std::out_of_range) {
            if (i >= 0 && i < self->size())
                (*self)[i] = val;
            else
                throw std::out_of_range("vector index out of range");
        }
    }
};

%define VECTOR_DEFINE(K)
    %template(_VECTOR_ ## K) vector<K>;
%enddef

};
