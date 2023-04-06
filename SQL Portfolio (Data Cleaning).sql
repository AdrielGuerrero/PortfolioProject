
-- Data Cleaning in SQL Queries 


 select * from PortfolioProject.dbo.NashvilleHousing




 ------------------------------------------------------------------------------------------------------




 --Standerize date format

  select SaleDateConverted, CONVERT(Date, SaleDate)
  from PortfolioProject.dbo.NashvilleHousing

  update NashvilleHousing
  Set SaleDate = Convert(Date, SaleDate)

  alter table NashvilleHousing
  add SaleDateConverted Date ;

  update NashvilleHousing
  set SaleDateConverted = Convert (Date, SaleDate)



---------------------------------------------------------------------------------------------------------------------





 --Populate Property Address data

  select * from PortfolioProject.dbo.NashvilleHousing
  --where PropertyAddress is null
  order by ParcelID


   select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
   from PortfolioProject.dbo.NashvilleHousing a
   join PortfolioProject.dbo.NashvilleHousing b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b. [UniqueID ]
   where a.PropertyAddress is null


   update a 
   set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
   from PortfolioProject.dbo.NashvilleHousing a
   join PortfolioProject.dbo.NashvilleHousing b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b. [UniqueID ]
   where a.PropertyAddress is null



   -----------------------------------------------------------------------------------------------------------------------




   --Breaking out Address Into Individual Columns (Address, City, State)

  select PropertyAddress
  from PortfolioProject.dbo.NashvilleHousing


  select SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as address
   
   , SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, len(PropertyAddress)) as address
  
  from PortfolioProject.dbo.NashvilleHousing



  alter table NashvilleHousing
  add PropertySplitAddress Nvarchar(255) ;

  update NashvilleHousing
  set PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)



    alter table NashvilleHousing
  add PropertySplitCity Nvarchar(255) ;

  update NashvilleHousing
  set PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, len(PropertyAddress))


 - select * from PortfolioProject.dbo.NashvilleHousing




  - select OwnerAddress from PortfolioProject.dbo.NashvilleHousing



  select PARSENAME(replace (OwnerAddress,',', '.'), 3)
 ,PARSENAME(replace (OwnerAddress,',', '.'), 2)
 , PARSENAME(replace (OwnerAddress,',', '.'), 1)
 
 
 from PortfolioProject.dbo.NashvilleHousing


  alter table NashvilleHousing
  add OwnerSplitAddress Nvarchar(255) ;

  update NashvilleHousing
  set OwnerSplitAddress = PARSENAME(replace (OwnerAddress,',', '.'), 3)



 alter table NashvilleHousing
  add OwnerSplitCity Nvarchar(255) ;

  update NashvilleHousing
  set OwnerSplitCity = PARSENAME(replace (OwnerAddress,',', '.'), 2)




   alter table NashvilleHousing
  add OwnerSplitState Nvarchar(255) ;

  update NashvilleHousing
  set OwnerSplitState = PARSENAME(replace (OwnerAddress,',', '.'), 1)



  select * from PortfolioProject.dbo.NashvilleHousing




  -------------------------------------------------------------------------------------------------





  -- Change Y and N to Yes and No in "Sold as Vacant" field

  select distinct(SoldAsVacant) , count(SoldAsVacant)
  from PortfolioProject.dbo.NashvilleHousing
  group by SoldAsVacant
  order by 2


  select SoldAsVacant,
  case when SoldAsVacant = 'Y' then 'Yes'
  when SoldAsVacant = 'N' then 'NO'
  else SoldAsVacant
  end
  from  PortfolioProject.dbo.NashvilleHousing


  update NashvilleHousing
  set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
  when SoldAsVacant = 'N' then 'NO'
  else SoldAsVacant
  end



  -----------------------------------------------------------------------------------------------------------



 --Remove Duplicates
 WITH rowNumCTE As (
 select * ,
	ROW_Number () Over (
	 partition by ParcelID, 
	 PropertyAddress,
	 SalePrice,
	 SaleDate,
	 LegalReference
	 order by 
		UniqueID) 
			row_num
 
 
from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID

)
 delete from rowNumCTE
 where row_num > 1
-- order by PropertyAddress
 
 
 
 select * from PortfolioProject.dbo.NashvilleHousing



 ------------------------------------------------------------------------------------------------------------------


 --delete unused column


 select * from PortfolioProject.dbo.NashvilleHousing

 alter table PortfolioProject.dbo.NashvilleHousing
 drop column OwnerAddress, TaxDistrict, PropertyAddress,


  alter table PortfolioProject.dbo.NashvilleHousing
 drop column SaleDate
































