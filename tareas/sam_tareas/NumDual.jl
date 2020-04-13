module NumDual
struct Dual{ T <: Real}
x :: T
y :: T
end
Dual(x::T) where {T<:Real} = Dual{T}(x,zero(x))
import Base: show, +, *, -, /
+(a::Dual, b::Dual) = Dual(a.x + b.x,a.y + b.y)
-(a::Dual, b::Dual) = Dual(a.x - b.x,a.y - b.y)
*(a::Dual, b::Dual) = Dual(a.x*b.x,a.x*b.y + b.x*a.y)
/(a::Dual, b::Dual) = Dual(a.x/b.x,(b.x*a.y-a.x*b.y)/b.x^2)

+(a::T, b::Dual) where {T<:Real} = Dual(a + b.x, b.y)
+(a::Dual, b::T) where {T<:Real}  = b + a

*(a::T, b::Dual ) where {T<:Real} = Dual(a * b.x, a * b.y)
*(a::Dual, b::T) where {T<:Real}  = b * a

-(a::T, b::Dual) where {T<:Real} = Dual(a - b.x, -b.y)
-(a::Dual, b::T) where {T<:Real}  = Dual(a.x - b, a.y)

/(a::T, b::Dual) where {T<:Real} = Dual(a / b.x, -a * b.y/(b.x^2))
/(a::Dual, b::T) where {T<:Real}  = Dual(a.x / b, a.y / b)

var_dual(x) = Dual(x,one(x))

import Base: sin,cos,tan,^,sqrt,exp,log
sin(a::Dual) = Dual(sin(a.x), a.y*cos(a.x))
cos(a::Dual) = Dual(cos(a.x), -a.y*sin(a.x))
^(a::Dual, n::Int) = Dual(a.x^n,n*a.x^(n-1)*a.y)
exp(a::Dual) = Dual(exp(a.x),a.y*exp(a.x))
log(a::Dual) = Dual(log(a.x) , a.y/a.x)
tan(a::Dual) = Dual(tan(a.x) , a.y*(1/(cos(a.x)^2)) )
sqrt(a::Dual) = Dual(sqrt(a.x) , a.y*(1/2*sqrt(a.x)))
end
