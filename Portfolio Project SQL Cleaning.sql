SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------
--Changing the Date Format

SELECT SaleDateConverted, CONVERT(date,SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add SaleDateConverted  Date

Update PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(date,SaleDate)

---------------------------------------------------------------------

--Populating Property Adress

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress is null
order by ParcelID

-- This query selects the parcel id and property address, and joins to itself. This allows us to replace all of the null property addresses with the property adress of the same parcel ID. 

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
      on a.ParcelID = b.ParcelID
	  AND a.UniqueID <> b.uniqueID
--WHERE a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
      on a.ParcelID = b.ParcelID
	  AND a.UniqueID <> b.uniqueID


-------------------------------------------------------------------

--Sepereating Adress into 3 different columns

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

FROM PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress  nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity  nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

--Getting the three seperate columns using PARSENAME

SELECT OwnerAddress 
FROM PortfolioProject.dbo.NashvilleHousing


--This seperates the address into the desired three columns.

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.') , 3),
PARSENAME(REPLACE(OwnerAddress,',','.') , 2),
PARSENAME(REPLACE(OwnerAddress,',','.') , 1)

FROM PortfolioProject.dbo.NashvilleHousing


-- This updates all of the columns with the coreect data

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress  nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') , 3)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity  nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') , 2)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState  nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') , 1)


--------------------------------------------------------------------------------------------------

-- Changing the format of the Y and N column

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
order by 2


SELECT SoldAsVacant, 
	CASE When SoldAsVacant = 'Y' THEN 'Yes'
		 When SoldAsVacant = 'N' THEN 'No'
		 Else SoldAsVacant
		 END
FROM PortfolioProject.dbo.NashvilleHousing


UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		 When SoldAsVacant = 'N' THEN 'No'
		 Else SoldAsVacant
		 END


-----------------------------------------------------


--Removing Duplicates


WITH RowNumCTE AS(
 SELECT *, 
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID, 
				 PropertyAddress, 
				 SalePrice, 
				 SaleDate, 
				 LegalReference
				 ORDER BY 
					UniqueID
					)row_num

FROM PortfolioProject.dbo.NashvilleHousing

)
DELETE
FROM RowNumCTE
WHERE row_num > 1


---------------------------------------------------------------------------------------

--Removing unused columns

SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

