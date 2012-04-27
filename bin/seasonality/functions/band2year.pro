FUNCTION  Band2Year, Bands, StartingYear, NumberOfBands, BandsPerYear


Return, StartingYear + (Float(Bands) mod NumberOfBands)/BandsPerYear
END
