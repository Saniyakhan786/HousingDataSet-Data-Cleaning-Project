

Select *
From [Data Cleaning].dbo.Housing

-- Standardize Date Format------------------------------------------------------------

Select SaleDate
From [Data Cleaning].dbo.Housing

Select SaleDate,CONVERT(date,SaleDate)
From [Data Cleaning].dbo.Housing


Update [Data Cleaning].dbo.Housing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE [Data Cleaning].dbo.Housing
Add SaleDateConverted Date;

Update [Data Cleaning].dbo.Housing
SET SaleDateConverted = CONVERT(Date,SaleDate)


Select SaleDateConverted, CONVERT(Date,SaleDate)
From [Data Cleaning].dbo.Housing


Select PropertyAddress
From [Data Cleaning].dbo.Housing
Where PropertyAddress is null

--To check the whole null values
Select *
From [Data Cleaning].dbo.Housing
Where PropertyAddress is null

-- Populate Property Address data-----------------------------------------------------------------

Select *
From [Data Cleaning].dbo.Housing
Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Data Cleaning].dbo.Housing a
JOIN [Data Cleaning].dbo.Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Data Cleaning].dbo.Housing a
JOIN [Data Cleaning].dbo.Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Data Cleaning].dbo.Housing a
JOIN [Data Cleaning].dbo.Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)-------------------------------------------

Select PropertyAddress
From [Data Cleaning].dbo.Housing
--Where PropertyAddress is null
--order by ParcelI

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From [Data Cleaning].dbo.Housing

ALTER TABLE [Data Cleaning].dbo.Housing
Add PropertySplitAddress Nvarchar(255);

Update [Data Cleaning].dbo.Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [Data Cleaning].dbo.Housing
Add PropertySplitCity Nvarchar(255);

Update [Data Cleaning].dbo.Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From [Data Cleaning].dbo.Housing



Select OwnerAddress
From [Data Cleaning].dbo.Housing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Data Cleaning].dbo.Housing


ALTER TABLE [Data Cleaning].dbo.Housing
Add OwnerSplitAddress Nvarchar(255);

Update [Data Cleaning].dbo.Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Data Cleaning].dbo.Housing
Add OwnerSplitCity Nvarchar(255);

Update [Data Cleaning].dbo.Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE [Data Cleaning].dbo.Housing
Add OwnerSplitState Nvarchar(255);

Update [Data Cleaning].dbo.Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From [Data Cleaning].dbo.Housing

-- Change Y and N to Yes and No in "Sold as Vacant" field-------------------------------------------------------

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Data Cleaning].dbo.Housing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Data Cleaning].dbo.Housing


Update [Data Cleaning].dbo.Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
	   
Select *
From [Data Cleaning].dbo.Housing

-- Remove Duplicates------------------------------------------------------------------------------------------

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From [Data Cleaning].dbo.Housing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


Select *
From [Data Cleaning].dbo.Housing


-- Delete Unused Columns----------------------------------------------------------------------------------

Select *
From [Data Cleaning].dbo.Housing


ALTER TABLE [Data Cleaning].dbo.Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
