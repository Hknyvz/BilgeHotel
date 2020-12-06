create trigger trg_MaasHesaplaInsert
on Vardiyalar
after insert
as
begin

	declare @CalisanId smallint
	declare @BaslamaTarihSaat datetime
	declare @BitisTarihSaat datetime
	declare @Maas decimal(7,2)
	declare @HesaplananMaas decimal(7,2)
	select @CalisanId=CalisanId, @BaslamaTarihSaat=BaslamaTarihSaat, @BitisTarihSaat=BitisTarihSaat from inserted
	select @Maas=m.Maas from Maaslar as m
	join Calisanlar as c on c.MaasId=m.Id where c.Id=@CalisanId
	set @HesaplananMaas=DATEDIFF(hour,@BaslamaTarihSaat,@BitisTarihSaat)*@Maas

	update MaasHesaplamalar set Ucret=Ucret+@HesaplananMaas where CalisanId=@CalisanId
end

