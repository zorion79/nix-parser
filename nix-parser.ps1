Install-Module ImportExcel -Scope CurrentUser
Import-Module ImportExcel

$urls = Import-Excel .\urls.xlsx
# $url = "https://www.nix.ru/autocatalog/server_systems_intel/Intel-2U-R2208WT2YSR-LGA2011-3-C612-2xPCI-E-SVGA-SATA-RAID-8xHotSwapSAS-SATA-2xGbLAN-24DDR4-1100W_280008.html"

$result = @()
foreach ($url in $urls) {
    $webResponse = Invoke-WebRequest $url.url

    $price = (($webResponse.ParsedHtml.getElementsByTagName("table") | Where-Object { $_.id -eq "goods_buttons" }).getElementsByTagName("span"))[0].textContent
    $name = ((($webResponse.ParsedHtml.getElementsByTagName("div") | `
                    Where-Object { $_.id -eq "goods_center" }).getElementsByTagName("span") | `
                Where-Object { $_.id -eq "goods_name" }).getElementsByTagName("span"))[0].textContent

    $o = [PSCustomObject]@{
        url   = $url.P1
        price = $price -replace '\s', '' -replace 'руб.', ''
        name  = $name
    }
    $result += $o
}

$result | Export-Excel .\urls.xlsx -AutoSize -Show