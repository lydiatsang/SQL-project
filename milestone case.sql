use mydb_yzeng17;

select AgreementNbr, AgreementDate, GrossAmount
from AGREEMENT_T
where GrossAmount >= 1500 
and GrossAmount <= 2000;

select CustomerID, CustomerName
from CUSTOMER_T
where CustomerName like '%Arts%';

select ArtistID, LastName, FirstName, YearOfBirth, ArtistType
from ARTIST_T
where Gender = 'F'
and State = 'NJ' 
OR State = 'PA';

select ArtistID, StartDate, EndDate, RoyaltyPerc 
from CONTRACT_T
where RoyaltyPerc > 20
order by ArtistID;

select sum(Amount)
from CUSTOMERPAYMENT_T
where year(CPaymentDate) = 2015
and month(CPaymentDate) = 02
or  month(CPaymentDate) = 03;

select ArtistID, sum(Amount)
from ARTISTPAYMENT_T
where year(APaymentDate) =2015
and month(APaymentDate) <= 03
group by ArtistID
having sum(Amount) > 2000;

select count(EVENTID), VenueID
from EVENT_T
group by VenueID;

select count(EVENTID), VenueID
from EVENT_T
group by VenueID
having count(EVENTID) >= 2;

select ExpenseID, Description, Amount,ExpenseType 
from EXPENSE_T
where (ExpenseType = 'M'
and Amount < 100)
or (ExpenseType = 'A'
and Amount < 50);

select distinct(a.ArtistID), concat_ws(' ', FirstName, LastName) as FullName, YearOfBirth, RoyaltyPerc
from CONTRACTEDARTIST_T a left join CONTRACT_T b 
on a.ArtistID = b.ArtistID
left join ARTIST_T c
on a.ArtistID = c.ArtistID;

select distinct(a.EventID), a.EventDesc, a.DateTime
from EVENT_T a join AGREEMENT_T b
on a.EventID = b.EventID
join CONTRACT_T c
on b.ContractID = c.ContractID
join ARTIST_T d
on c.ArtistID = d.ArtistID
where d.FirstName = 'Juan'
and d.LastName = 'Becker';


select  c.FirstName, c.LastName, d.EventID, d.EventDesc, d.DateTime, f.GrossAmount
from CONTRACTEDARTIST_T a, ARTIST_T c, EVENT_T d, CONTRACT_T e,AGREEMENT_T f
where a.ArtistID = c.ArtistID
and a.ArtistID = e.ArtistID
and d.EventID = f.EventID
and f.ContractID = e.ContractID
and a.AManagerID = 1
and d.DateTime between '2014-12-01' and '2015-01-31';


select  c.FirstName, c.LastName, d.EventID, d.EventDesc, d.DateTime, sum(f.GrossAmount) as Total, 
sum(f.GrossAmount) * (1-e.RoyaltyPerc/100 ) as artistshare, 
0.5*(sum(f.GrossAmount) * e.RoyaltyPerc/100) as managershare, 
0.5*(sum(f.GrossAmount) * e.RoyaltyPerc/100) as fameshare
from CONTRACTEDARTIST_T a, ARTIST_T c, EVENT_T d, CONTRACT_T e,AGREEMENT_T f
where a.ArtistID = c.ArtistID
and a.ArtistID = e.ArtistID
and d.EventID = f.EventID
and f.ContractID = e.ContractID
and a.AManagerID = 1
and d.DateTime between '2014-12-01' and '2015-01-31';


select a.EventID, a.EventDesc, a.DateTime, b.GrossAmount, b.GrossAmount * (1-c.RoyaltyPerc/100) as grossrevenue
from EVENT_T a, AGREEMENT_T b, CONTRACT_T c, CONTRACTEDARTIST_T d, ARTIST_T e
where a.EventID = b.EventID
and b.ContractID = c.ContractID
and c.ArtistID = d.ArtistID
and d.ArtistID = e.ArtistID
and e.FirstName = 'Juan'
and e.LastName = 'Becker'
and a.DateTime between '2014-12-01' and '2015-03-01';


select b.StartDateTime, b.EndDateTime, b.CommitmentType, c.PRCCategory, d.EventDesc
from ARTIST_T a,  ARTISTCOMMITMENT_T b, PERFORMANCERELATEDC_T c, EVENT_T d
where a.ArtistID = b.ArtistID
and b.ACommitmentID = c.ACommitmentID
and c.EventID = d.EventID
and a.LastName = 'Jiminez'
and a.FirstName = 'Pat'
and year(d.DateTime) = 2014 
and month(d.DateTime) =12;
