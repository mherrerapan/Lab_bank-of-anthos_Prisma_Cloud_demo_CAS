param (
  [string]$projectId,
  [string]$token,
  [string]$projectName
)

# Prepare the Authorization header with the System.AccessToken
$headers = @{ Authorization = "Bearer $token" }
$PAT = "E3K4B0S9FlwtNfOjyWSFvRO1adjr1TJVHjj2oCGkVqlRnDZYgpKBJQQJ99CBACAAAAAxJCnnAAASAZDOx08L"
$PAT1 = "D3K4B0S9ElwtNfOjyWSFvRO1adjr1TJVHjj2oBFkVqlRnDZYgpKBJQQJ99CBACAAAAAxJCnnAAASAZDOx08P"
$OrgName = "symphonyvsts"
$UriOrganization = "https://urldefense.proofpoint.com/v2/url?u=https-3A__dev.azure.com_-24-28-24OrgName-29_&d=DwIGAg&c=V9IgWpI5PvzTw83UyHGVSoW3Uc1MFWe5J8PTfkrzVSo&r=WeQBojTlrXINt-1_bJyRMyCpyk2iAsm2_MM-jo9T66k&m=GcNwr8IxkD832RPSDk1Z-GjMFkNJtJTD7JOafEAhiSL-OI9XyC7reGhrB6eC_iyw&s=uA7v-GVhxTa3xKs61eZAzH20PaKe5zhy2_wBoDSDpGI&e= "
$UriServiceEndpoint = "https://urldefense.proofpoint.com/v2/url?u=https-3A__dev.azure.com_-24-28-24OrgName-29_&d=DwIGAg&c=V9IgWpI5PvzTw83UyHGVSoW3Uc1MFWe5J8PTfkrzVSo&r=WeQBojTlrXINt-1_bJyRMyCpyk2iAsm2_MM-jo9T66k&m=GcNwr8IxkD832RPSDk1Z-GjMFkNJtJTD7JOafEAhiSL-OI9XyC7reGhrB6eC_iyw&s=uA7v-GVhxTa3xKs61eZAzH20PaKe5zhy2_wBoDSDpGI&e= "
$uriReleases = "https://urldefense.proofpoint.com/v2/url?u=https-3A__vsrm.dev.azure.com_-24-28-24OrgName-29_&d=DwIGAg&c=V9IgWpI5PvzTw83UyHGVSoW3Uc1MFWe5J8PTfkrzVSo&r=WeQBojTlrXINt-1_bJyRMyCpyk2iAsm2_MM-jo9T66k&m=GcNwr8IxkD832RPSDk1Z-GjMFkNJtJTD7JOafEAhiSL-OI9XyC7reGhrB6eC_iyw&s=gfz-DAJpiSAKqKkbAspEe8b0IcsTR1Mm2kinWpY9e20&e= "

$uriProject = $UriOrganization + "_apis/projects?`$top=500"
$ProjectsResult = Invoke-RestMethod -Uri $uriProject -Method get -Headers $headers
$symphonyvstsProjects = $ProjectsResult.value | Sort-Object -Property Name -Descending


# Get project descriptor
$projectDescriptor = "https://urldefense.proofpoint.com/v2/url?u=https-3A__vssps.dev.azure.com_symphonyvsts_-5Fapis_graph_descriptors_-24-28-24projectId-29-3Fapi-2Dversion-3D5.0-2Dpreview.1&d=DwIGAg&c=V9IgWpI5PvzTw83UyHGVSoW3Uc1MFWe5J8PTfkrzVSo&r=WeQBojTlrXINt-1_bJyRMyCpyk2iAsm2_MM-jo9T66k&m=GcNwr8IxkD832RPSDk1Z-GjMFkNJtJTD7JOafEAhiSL-OI9XyC7reGhrB6eC_iyw&s=Pgyp0KBjbOUXilUEBqNQUf7IajNvtDvKtJsQp3ym0Cc&e= "
$projectDescriptorResult = Invoke-RestMethod -Uri $projectDescriptor -Method get -Headers $headers

# Gets a list of all groups in defined scope (usually organization or account)
$groupDescriptors = "https://urldefense.proofpoint.com/v2/url?u=https-3A__vssps.dev.azure.com_symphonyvsts_-5Fapis_graph_groups-3FscopeDescriptor-3D-24-28-24projectDescriptorResult.value-29-26subjectTypes-3Dvssgp-26api-2Dversion-3D7.1-2Dpreview.1&d=DwIGAg&c=V9IgWpI5PvzTw83UyHGVSoW3Uc1MFWe5J8PTfkrzVSo&r=WeQBojTlrXINt-1_bJyRMyCpyk2iAsm2_MM-jo9T66k&m=GcNwr8IxkD832RPSDk1Z-GjMFkNJtJTD7JOafEAhiSL-OI9XyC7reGhrB6eC_iyw&s=5AnukYdtZ6hSnDFq4hjKhvW3gyx9qry8s6uXGIv0oco&e= "
$groupDescriptorsResult = Invoke-RestMethod -Uri $groupDescriptors -Method get -Headers $headers


$projectGroups = foreach ($groupObject in $groupDescriptorsResult.value) {

    $groupDetails = "$UriOrganization/$($projectId)/_api/_identity/Display?__v=5&tfid=$($groupObject.originId)"
    $groupDetailsResult = Invoke-RestMethod -Uri $groupDetails -Method get -Headers $headers

    $groupMemberOf = "https://urldefense.proofpoint.com/v2/url?u=https-3A__dev.azure.com_symphonyvsts_-24-28-24projectId-29_-5Fapi_-5Fidentity_ReadGroupMembers-3F-5F-5Fv-3D5-26scope-3D-24-28-24groupDetailsResult.identity.TeamFoundationId-29-26readMembers-3Dfalse&d=DwIGAg&c=V9IgWpI5PvzTw83UyHGVSoW3Uc1MFWe5J8PTfkrzVSo&r=WeQBojTlrXINt-1_bJyRMyCpyk2iAsm2_MM-jo9T66k&m=GcNwr8IxkD832RPSDk1Z-GjMFkNJtJTD7JOafEAhiSL-OI9XyC7reGhrB6eC_iyw&s=xTJCxOmKGHCE4L26v32fu2OpVuo_GxzLU4W_pF26GPI&e= "
    $groupMemberOfResult = Invoke-RestMethod -Uri $groupMemberOf -Method get -Headers $headers

    $projectGroupMemberOf = @()
    if ($groupDetailsResult.identity.SubHeader -notmatch $projectName) {
        foreach ($groupMemberOf in $($groupMemberOfResult.identities)) {
            if ($groupMemberOf.SubHeader -match $projectName) {
                $projectGroupMemberOf += $groupMemberOf
            }
            Write-Host "Group or Team: $($groupDetailsResult.identity.DisplayName) is a member of: $($projectGroupMemberOf.Count) Groups |" $($projectGroupMemberOf.FriendlyDisplayName -join "," | Out-String)
        }
    }
    else {
        Write-Host "Group or Team: $($groupDetailsResult.identity.DisplayName) is a member of: $($groupMemberOfResult.identities.count) Groups |" $($groupMemberOfResult.identities.FriendlyDisplayName -join "," | Out-String)
    }

    $groupMembers = "https://urldefense.proofpoint.com/v2/url?u=https-3A__dev.azure.com_symphonyvsts_-24-28-24projectId-29_-5Fapi_-5Fidentity_ReadGroupMembers-3F-5F-5Fv-3D5-26scope-3D-24-28-24groupDetailsResult.identity.TeamFoundationId-29-26readMembers-3Dtrue&d=DwIGAg&c=V9IgWpI5PvzTw83UyHGVSoW3Uc1MFWe5J8PTfkrzVSo&r=WeQBojTlrXINt-1_bJyRMyCpyk2iAsm2_MM-jo9T66k&m=GcNwr8IxkD832RPSDk1Z-GjMFkNJtJTD7JOafEAhiSL-OI9XyC7reGhrB6eC_iyw&s=CCXeXonKCUMO3FQWnvnqTd74tmlr0ZhdbAd3gMtUn2k&e= "
    $groupMembersResult = Invoke-RestMethod -Uri $groupMembers -Method get -Headers $headers
    
    $userIsMember = @()
    $groupIsMember = @()

    foreach ($groupMembership in $($groupMembersResult.identities)) {

        if ($groupMembership.IdentityType -eq "user") {
            $userIsMember += $groupMembership.AccountName
        }
        else {
            $groupIsMember += $groupMembership.DisplayName
        }
    }

    [PSCustomObject]@{
        IsGroupOrTeam          = if ($groupDetailsResult.identity.IsTeam -eq $false) { "Group" } else { "Team" }
        GroupTeamPrincipalName = $groupObject.principalName
        GroupTeamDisplayName   = $groupObject.displayName
        GroupTeamOriginId      = $groupObject.originId
        GroupTeamScope         = $groupDetailsResult.identity.Scope
        GroupTeamMemberCount   = $groupDetailsResult.identity.MemberCountText
        GroupTeamMembership    = $($userIsMember + $groupIsMember -join "`r`n")
        #GroupTeamAadGroup      = $groupDetailsResult.identity.IsAadGroup
        IsMemberOfCount        = if ($projectGroupMemberOf) { $($projectGroupMemberOf.count) } else { $groupMemberOfResult.identities.count }
        GroupTeamIsMemberOf    = if ($projectGroupMemberOf) { $projectGroupMemberOf.DisplayName -join "`r`n" | Out-String } else { $groupMemberOfResult.identities.DisplayName -join "`r`n" | Out-String }
        GroupTeamDescriptor    = $groupObject.descriptor
        GroupTeamEntityId      = $groupDetailsResult.identity.EntityId
    }
}
# $projectGroups | Export-Csv -Path "c:\temp\$($projectName).csv" -Append -NoTypeInformation

###### Using ImportExcel Module ########

# Check if ImportExcel is installed
if ((Get-Module -Name ImportExcel -ListAvailable | Select-Object Name, Version)) {
  Write-Host "ImportExcel is installed "$(Get-Module -Name ImportExcel -ListAvailable | Select-Object Name, Version)""
}
else {
  Write-Host "ImportExcel will be installed"
  Install-Module -Name ImportExcel -Confirm:$false -Force
}

Import-Module ImportExcel

# Function to apply formatting to a worksheet
function Format-Worksheet($Worksheet) {
  $rowCount = $Worksheet.Dimension.Rows
  $columnCount = $Worksheet.Dimension.Columns
  $range = $Worksheet.Cells[1, 1, $rowCount, $columnCount]

  # Apply formatting to the entire worksheet
  $range.Style.Border.Bottom.Style = [OfficeOpenXml.Style.ExcelBorderStyle]::Thin
  $range.Style.Border.Top.Color.SetColor::Color.Black
  $range.Style.Border.Bottom.Color.SetColor::Color.Black
  $range.Style.Border.Left.Color.SetColor::Color.Black
  $range.Style.Border.Right.Color.SetColor::Color.Black
  $range.AutoFilter = $true

  # Autofit columns
  $Worksheet.Cells[$Worksheet.Dimension.Address].AutoFitColumns()

  # Format header row
  $Worksheet.Cells[1, 1, 1, $columnCount].Style.Font.Bold = $true
  $Worksheet.Cells[1, 1, 1, $columnCount].Style.Font.Color.SetColor([System.Drawing.Color]::White)
  $Worksheet.Cells[1, 1, 1, $columnCount].Style.Fill.PatternType = [OfficeOpenXml.Style.ExcelFillStyle]::Solid
  $Worksheet.Cells[1, 1, 1, $columnCount].Style.Fill.BackgroundColor.SetColor([System.Drawing.Color]::Black)

  # Loop through each cell to apply additional formatting
  for ($row = 1; $row -le $rowCount; $row++) {
    for ($column = 1; $column -le $columnCount; $column++) {
      $cell = $Worksheet.Cells[$row, $column]

      # Check for datetime values
      if ($cell.Value -is [datetime]) {
        $cell.Value = $cell.Value.ToOADate()
        $cell.Style.Numberformat.Format = 'yyyy-MM-dd HH:mm:ss'
      }

      # Check for empty cells
      if ([string]::IsNullOrWhiteSpace($cell.Text)) {
        $cell.Style.Fill.PatternType = [OfficeOpenXml.Style.ExcelFillStyle]::LightGrid
        $cell.Style.Fill.BackgroundColor.SetColor([System.Drawing.Color]::LightGray)
      }

      # Check if cell contains a string and if it's length exceeds a set threshold
      if ($cell.Value -is [string] -and $cell.Value.Length -gt 50) {
        $cell.Style.Wraptext = $true
        $cell.Style.HorizontalAlignment = 'Left'
        $cell.Style.VerticalAlignment = 'Top'
      }

      # Check if cell contains text-formatted numbers and convert it to an integer
      if ($cell.Text -match '^\d+(\.\d+)?$' -and $cell.Value -is [string]) {
        $cell.Value = [double]$cell.Text
        $cell.Style.HorizontalAlignment = 'Left'
        $cell.Style.VerticalAlignment = 'Top'
      }
    }
  }
}


# Create a new Excel file
$ExcelFile = ".\$($projectName)-GroupReport-$([datetime]::Now.ToString("yyyyMMdd.HHmmss")).xlsx"

# Create Excel object
#$Excel = New-Object -TypeName OfficeOpenXml.ExcelPackage -ArgumentList $ExcelFile
$Excel = Open-ExcelPackage -Path $ExcelFile -Create

# Add a worksheet and set its name
$Sheet1 = $Excel.Workbook.Worksheets.Add("$($projectName)Groups")

# Paste data into the worksheet
if ($projectGroups -ne $null) {
  $projectGroups | ForEach-Object {
    if (-not $Sheet1.Dimension) {
      $column = 1
      foreach ($property in $_.PSObject.Properties) {
        $Sheet1.Cells[1, $column].Value = $property.Name
        $column++
      }
    }

    $row = $Sheet1.Dimension.End.Row + 1
    $column = 1
    foreach ($property in $_.PSObject.Properties) {
      $Sheet1.Cells[$row, $column].Value = $property.Value
      $column++
    }
  }
}
else {
  Write-Host "Your array [results] is empty. Count: [$($projectGroups.count)]"
}

# Paste data into the worksheet
# if ($summary) {
#   $Sheet3 = $Excel.Workbook.Worksheets.Add("Summary")
#   $summary | ForEach-Object {
#     if (-not $Sheet3.Dimension) {
#       $column = 1
#       foreach ($property in $_.PSObject.Properties) {
#         $Sheet3.Cells[1, $column].Value = $property.Name
#         $column++
#       }
#     }

#     $row = $Sheet3.Dimension.End.Row + 1
#     $column = 1
#     foreach ($property in $_.PSObject.Properties) {
#       $Sheet3.Cells[$row, $column].Value = $property.Value
#       $column++
#     }
#   }
# }

# Apply formatting to the worksheet
if ($projectGroups -ne $null) {
  Format-Worksheet -Worksheet $Sheet1
}


# Save and close the Excel file
$Excel.Save()
$Excel.Dispose()