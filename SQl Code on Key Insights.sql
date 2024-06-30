select * from [dbo].[kalvium_ParliamentaryAssembly Constituencies]

/*Total Constituencies per State*/

SELECT State, COUNT(*) AS Total_Constituencies
FROM [dbo].[kalvium_ParliamentaryAssembly Constituencies]
GROUP BY State;

/*Number of Candidates by Party*/

SELECT leading_party AS Party, COUNT(*) AS Number_of_Candidates
FROM [dbo].[kalvium_ParliamentaryAssembly Constituencies]
GROUP BY leading_party;

/*Winning Percentage by Party*/

SELECT leading_party AS Party, 
       (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[kalvium_ParliamentaryAssembly Constituencies])) AS Winning_Percentage
FROM [dbo].[kalvium_ParliamentaryAssembly Constituencies]
WHERE Status = 'Result Declared'
GROUP BY leading_party;



/*Total Votes by State*/

SELECT State, SUM(Margin) AS Total_Votes
FROM [dbo].[kalvium_ParliamentaryAssembly Constituencies]
GROUP BY State;

/*Candidate Success Rate: Percentage of candidates from each party who won.*/

SELECT 
    leading_party AS Party,
    COUNT(*) AS Total_Candidates,
    SUM(CASE WHEN Status = 'Result Declared' THEN 1 ELSE 0 END) AS Candidates_Won,
    (SUM(CASE WHEN Status = 'Result Declared' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Success_Rate
FROM 
    [dbo].[kalvium_ParliamentaryAssembly Constituencies]
GROUP BY 
    leading_party;

/*Regional Strength: Strongest performing party in each state*/

SELECT State, Party
FROM (
    SELECT State, leading_party AS Party,
           ROW_NUMBER() OVER (PARTITION BY State ORDER BY SUM(Margin) DESC) AS Party_Rank
    FROM [dbo].[kalvium_ParliamentaryAssembly Constituencies]
    GROUP BY State, leading_party
) ranked
WHERE Party_Rank = 1;

/*Constituencies with the smallest winning margins*/

SELECT TOP 10 Constituency, State, leading_party AS Winning_Party, Margin
FROM [dbo].[kalvium_ParliamentaryAssembly Constituencies]
WHERE Status = 'Result Declared'
ORDER BY Margin ASC;

/*Total number of different parties represented in each state*/

SELECT [State], COUNT(DISTINCT [leading_party]) AS PartiesRepresented
FROM [dbo].[kalvium_ParliamentaryAssembly Constituencies]
GROUP BY [State]
ORDER BY PartiesRepresented DESC;

/*The total number of constituencies*/

SELECT COUNT(*) AS TotalConstituencies
FROM [dbo].[kalvium_ParliamentaryAssembly Constituencies];

/*Total number of independent candidates*/
SELECT COUNT(*) AS IndependentCandidates
FROM [dbo].[kalvium_ParliamentaryAssembly Constituencies]
WHERE [leading_party] = 'Independent';
