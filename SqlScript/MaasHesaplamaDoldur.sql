declare @i int=1
while @i<(select count(Ad) from Calisanlar)+1
begin
	insert into MaasHesaplamalar(CalisanId,Ucret) values(@i,0)
	set @i=@i+1
end
select *from MaasHesaplamalar

