using timbpMisc, Test, Dates, Distributions

@testset "timbpMisc.jl" begin
  @testset "Financial years" begin
    d = Dates.Date("2019")
    @test FinancialYear(2019).value == 2019
    @test FinancialYear(d).value == 2019
    @test FinancialYear("2019").value == 2019
    @test FinancialYear("2019-06").value == 2019
    @test FinancialYear("2019-07").value == 2020
    @test FinancialYear("2019-06-30").value == 2019
    @test FinancialYear("2019-07-01").value == 2020
    @test FinancialYear(2019) - FinancialYear(2017) == Year(2)
    @test FinancialYear(2017) + Year(2) == FinancialYear(2019)
    @test FinancialYear(2017) - Year(2) == FinancialYear(2015)
    @test show(FinancialYear(d)) == print("2018/19")
    @test print(FinancialYear(d)) == 2019
    @test (FinancialYear(2019) < FinancialYear(2020)) == true
  end
  @testset "Control limits" begin
    @test controllimits(0.025, 50, .3) == 0.16613938031193454
    @test controllimits(0.975, 50, .3) == 0.4201358867168803
    @test controllimits.((0.025, 0.975), 50, .3) == (0.16613938031193454, 0.4201358867168803)
  end
end
