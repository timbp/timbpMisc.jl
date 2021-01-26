module timbpMisc

import Base.:-
import Base.:+
import Base.isless
import Base.show
import Base.print
import Dates

using Distributions

export FinancialYear
export controllimits
export agemonths

"""
    FinancialYear

Australian financial year (1 July to 30 June)
"""
struct FinancialYear
  value::Int16
end

"""
    FinancialYear(date::Dates.Date)

Create FinancialYear from Date
"""
function FinancialYear(date::Dates.Date)
  Dates.month(date) in 7:12 ? FinancialYear(Dates.year(date) + 1) : FinancialYear(Dates.year(date))
end

"""
    FinancialYear(date::String)

Create FinancialYear from String by parsing as Date
"""
FinancialYear(date::String) = FinancialYear(Dates.Date(date))

# FinancialYear show/print
function Base.show(io::IO, ::MIME"text/plain", fy::FinancialYear)
  write(io, string(fy.value - 1) * "/" * string(fy.value % 100, pad=2))
end

function Base.print(io::IO, fy::FinancialYear)
  fy.value
end

# FinancialYear arithmetic
(-)(fy::FinancialYear, ffy::FinancialYear) = Dates.Year(fy.value - ffy.value)
(+)(fy::FinancialYear, y::Dates.Year) = FinancialYear(fy.value + y.value % 100)
(-)(fy::FinancialYear, y::Dates.Year) = FinancialYear(fy.value - y.value % 100)

Base.isless(fy::FinancialYear, ffy::FinancialYear) = isless(fy.value, ffy.value)

Base.Broadcast.broadcastable(fy::FinancialYear) = Ref(fy)

"""
    controllimits(p, n, θ)

Calculate Spiegelhalter (2005) control limit for funnel plot.

`p ∈ (0.0, 1.0)`: quantile for the control limit

`n`: sample size (Integer)

`θ ∈ (0.0, 1.0)`: population value

### References

1. Spiegelhalter DJ. Funnel plots for comparing institutional performance.
   Stat Med. 2005;24:1185–202.


"""
function controllimits(p, n, θ)
  r = quantile(Binomial(n, θ), p)
  numerator = cdf(Binomial(n, θ), r) - p
  denominator = cdf(Binomial(n, θ), r) - cdf(Binomial(n, θ), r - 1)
  α = numerator / denominator
  limit = min(1.0, max(0.0, (r - α) / n))
end

"""
    agemonths(dob, date)

Calculate age in whole months from birthdate and date
"""
function agemonths(dob, date)
  y, m, d = Dates.yearmonthday(date) .- Dates.yearmonthday(dob)
  return 12y + m - (d < 0 ? 1 : 0)
end

end
