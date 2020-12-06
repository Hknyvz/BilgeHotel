create function fn_TarihSaatConvert
(
	@tarihsaat nvarchar(16)
)
returns datetime
begin

	declare @tarih nvarchar(13)
	set @tarih=dbo.fn_TarihConvert(SUBSTRING(@tarihsaat,1,10))
	declare @saat nvarchar(6)
	set @saat=SUBSTRING(@tarihsaat,11,6)
	return @tarih+@saat

end
go
create proc sp_VardiyaEkle
(
	@CalisanId smallint,
	@BaslamaTarihSaat nvarchar(16),
	@BitisTarihSaat nvarchar(16)
)
as
begin
	insert into Vardiyalar values
	(
		@CalisanId,
		dbo.fn_TarihSaatConvert(@BaslamaTarihSaat),
		dbo.fn_TarihSaatConvert(@BitisTarihSaat)
	)
end
go
exec sp_VardiyaEkle 1,'03/12/2020 08:05','03/12/2020 16:03'
go
exec sp_VardiyaEkle 2,'03/12/2020 15:58','04/12/2020 00:05'
go
exec sp_VardiyaEkle 3,'04/12/2020 00:00','04/12/2020 08:00'
go
exec sp_VardiyaEkle 4,'03/12/2020 08:05','03/12/2020 16:03'
go
exec sp_VardiyaEkle 5,'03/12/2020 15:58','04/12/2020 00:05'
go
exec sp_VardiyaEkle 6,'04/12/2020 00:00','04/12/2020 08:00'
go
