
/******************************************************************************
* MODULE     : vector.hpp
* DESCRIPTION: vectors with reference counting and pointer copying
* COPYRIGHT  : (C) 2006  Joris van der Hoeven
*******************************************************************************
* This software falls under the GNU general public license and comes WITHOUT
* ANY WARRANTY WHATSOEVER. See the file $TEXMACS_PATH/LICENSE for more details.
* If you don't have this file, write to the Free Software Foundation, Inc.,
* 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
******************************************************************************/

#ifndef VECTOR_H
#define VECTOR_H
#include "properties.hpp"
#include "operators.hpp"
#define TMPL template<typename T>

TMPL class vector;
TMPL int N (vector<T> a);
TMPL T* A (vector<T> a);

/******************************************************************************
* The vector class
******************************************************************************/

TMPL
class vector_rep: concrete_struct {
  int n;
  T* a;
public:
  inline vector_rep (T* a2, int n2): n(n2), a(a2) {}
  inline ~vector_rep () { delete[] a; }
  friend class vector<T>;
  friend int N LESSGTR (vector<T> a);
  friend T* A LESSGTR (vector<T> a);
};

TMPL
class vector {
CONCRETE_TEMPLATE(vector,T);
  inline vector (T *a, int n):
    rep (new vector_rep<T> (a, n)) {}
  inline vector (T c, int n) {
    T* a= new T[1]; a[0]= c1;
    for (int i=0; i<n; i++) a[i]= c;
    rep= new vector_rep<T> (a, n); }
  inline vector () {
    T* a= new T[0];
    rep= new vector_rep<T> (a, 0); }
  inline vector (T c1) {
    T* a= new T[1]; a[0]= c1;
    rep= new vector_rep<T> (a, 1); }
  inline vector (T c1, T c2) {
    T* a= new T[2]; a[0]= c1; a[1]= c2;
    rep= new vector_rep<T> (a, 2); }
  inline vector (T c1, T c2, T c3) {
    T* a= new T[3]; a[0]= c1; a[1]= c2; a[2]= c3;
    rep= new vector_rep<T> (a, 3); }
  inline T& operator [] (int i) { return rep->a[i]; }
};
CONCRETE_TEMPLATE_CODE(vector,typename,T);

TMPL inline int N (vector<T> v) { return v->n; }
TMPL inline T* A (vector<T> v) { return v->a; }

TMPL tree
as_tree (vector<T> v) {
  int i, n= N(v);
  T* a= A(v);
  tree t (TUPLE, n);
  for (i=0; i<n; i++)
    t[i]= as_tree (a[i]);
  return t;
}

TMPL inline ostream&
operator << (ostream& out, vector<T> v) {
  return out << as_math_string (as_tree (v));
}

TMPL
class properties<vector<T> > {
public:
  typedef T scalar_type;
  typedef typename properties<T>::norm_type norm_type;
  typedef int index_type;
};

/******************************************************************************
* Abstract operations on vectors
******************************************************************************/

template<typename T, typename Op> vector<T>
unary (vector<T> v) {
  int i, n= N(v);
  T* a= A(v);
  T* r= new T[n];
  for (i=0; i<n; i++)
    r[i]= Op::eval (a[i]);
  return vector<T> (r, n);
}

template<typename T, typename Op> vector<T>
binary (vector<T> v, vector<T> w) {
  int i, n= N(v);
  if (N(w) != n)
    fatal_error ("Vector lengths don't match", "binary<T,Op>", "vector.hpp");
  T* a= A(v);
  T* b= A(w);
  T* r= new T[n];
  for (i=0; i<n; i++)
    r[i]= Op::eval (a[i], b[i]);
  return vector<T> (r, n);
}

/******************************************************************************
* Standard operations on vectors
******************************************************************************/

TMPL inline vector<T>
operator - (vector<T> v) {
  return unary<T,neg_op> (v); }

TMPL inline vector<T>
operator + (vector<T> v, vector<T> w) {
  return binary<T,add_op> (v, w); }

TMPL inline vector<T>
operator - (vector<T> v, vector<T> w) {
  return binary<T,sub_op> (v, w); }

TMPL inline vector<T>
operator * (vector<T> v, vector<T> w) {
  return binary<T,mul_op> (v, w); }

TMPL inline vector<T>
operator / (vector<T> v, vector<T> w) {
  return binary<T,div_op> (v, w); }

TMPL inline vector<T>
sqrt (vector<T> v) {
  return unary<T,sqrt_op> (v); }

TMPL inline vector<T>
exp (vector<T> v) {
  return unary<T,exp_op> (v); }

TMPL inline vector<T>
log (vector<T> v) {
  return unary<T,log_op> (v); }

TMPL inline vector<T>
pow (vector<T> v, vector<T> w) {
  return binary<T,pow_op> (v, w); }

TMPL inline vector<T>
cos (vector<T> v) {
  return unary<T,cos_op> (v); }

TMPL inline vector<T>
sin (vector<T> v) {
  return unary<T,sinop> (v); }

TMPL inline vector<T>
tan (vector<T> v) {
  return unary<T,tan_op> (v); }

/******************************************************************************
* Casted operations on vectors
******************************************************************************/

TMPL vector<T>
operator + (T c, vector<T> v) {
  return vector<T> (c, N(v)) + v; }

TMPL vector<T>
operator + (vector<T> v, T c) {
  return v + vector<T> (c, N(v)); }

TMPL vector<T>
operator - (T c, vector<T> v) {
  return vector<T> (c, N(v)) - v; }

TMPL vector<T>
operator - (vector<T> v, T c) {
  return v - vector<T> (c, N(v)); }

TMPL vector<T>
operator * (T c, vector<T> v) {
  return vector<T> (c, N(v)) * v; }

TMPL vector<T>
operator * (vector<T> v, T c) {
  return v * vector<T> (c, N(v)); }

TMPL vector<T>
operator / (T c, vector<T> v) {
  return vector<T> (c, N(v)) / v; }

TMPL vector<T>
operator / (vector<T> v, T c) {
  return v / vector<T> (c, N(v)); }

#undef TMPL
#endif // defined VECTOR_H
