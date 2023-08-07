select *
from PortfolioProject..NashvilleHousing

-- Standardising the date format 
select SaleDateConverted, convert(date,SaleDate)
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SaleDate = convert(date,saledate)

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = convert(date,SaleDate)

-- populating the property address data

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


update a
set PropertyAddress = isnull(a.propertyaddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--sorting address into individual columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing


select
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) Address
, substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) Address

from PortfolioProject..NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress Nvarchar (255);

update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

alter table NashvilleHousing
add PropertySplitCity Nvarchar (255);

update NashvilleHousing
set PropertySplitCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


select OwnerAddress
from NashvilleHousing

select 
parsename(replace(OwnerAddress, ',', '.') ,3)
,parsename(replace(OwnerAddress, ',', '.') ,2)
,parsename(replace(OwnerAddress, ',', '.') ,1)
from NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress Nvarchar (255);

update NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.') ,3)

alter table NashvilleHousing
add OwnerSplitCity Nvarchar (255);

update NashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.') ,2)

alter table NashvilleHousing
add OwnerSplitState Nvarchar (255);

update NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress, ',', '.') ,1)

-- changing y to yes and n to no in "Sold as Vacant"

Select Distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2 

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from NashvilleHousing

-- removing duplicate values

with RowNumCTE as(
select *,
	row_number() over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by 
					UniqueID
					) row_num
from NashvilleHousing
)
delete
from RowNumCTE
where row_num > 1

-- dropping unused columns 

alter table NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
