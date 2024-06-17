let invitedStation = null;
let vehicle = null;
let vehPrice = null;
let player = null;
let claimId = null;

const convertValue = (value, oldMin, oldMax, newMin, newMax) => {
    const oldRange = oldMax - oldMin
    const newRange = newMax - newMin
    const newValue = ((value - oldMin) * newRange) / oldRange + newMin
    return newValue
}

$(function(){
    $(document).on("click", ".nav-item", function(){ 
        $(".nav-item").removeClass("active");
        $(this).addClass("active");
        var page = $(this).attr("data-href");
        $(".page").hide();
        $(`.page[data-page="${page}"]`).show();
        $(".header .btn").hide();

        if(page == "overview"){
            $(".header .btn").hide();
            $(".search-bar").hide();
            $(".header .sell-btn").show();
        }else if(page == "orders"){
            $(".header .btn").hide();
            $(".search-bar").show();
            $(".header .order-btn").show();
        }else{
            $(".header .btn").hide();
            $(".search-bar").show();
            $(".header .hire-btn").show();
        }
    })

    $(document).on("click", ".claim-order-btn", function(){ 
        $(".pop-up").hide()
        $(".pop-up-wrapper").fadeIn()
        $(".claim-order-page").fadeIn()
        $(".claim-order-page").css("display", "flex")
        claimId = $(this).data("orderid");
    })

    $(document).on("click", "#claim-order-btn", function(){ 
        if (!claimId) return;
        $(".pop-up-wrapper").fadeOut()
        $(".claim-order-page").fadeOut()
        $("body").fadeOut()
        $.post(`https://${GetParentResourceName()}/claimOrder`, JSON.stringify(claimId))
    })

    $(document).on("click", ".order-btn", function(){ 
        $(".pop-up").hide()
        $(".pop-up-wrapper").fadeIn()
        $(".new-order-page").fadeIn()
        $(".new-order-page").css("display", "flex")
    })

    $(document).on("click", "#create-order-btn", function(){ 
        let selectedVehicle = $("#vehicles-select").val();
        if (selectedVehicle == 0 || selectedVehicle == null) return;
        $.post(`https://${GetParentResourceName()}/createOrder`, JSON.stringify(selectedVehicle))
        $(".pop-up-wrapper").fadeOut()
        $(".new-order-page").fadeOut()
        $("body").fadeOut()
    })

    $(document).on("click", ".fire-employee", function(){ 
        $(".pop-up").hide()
        $(".pop-up-wrapper").fadeIn()
        $(".fire-confirm-page").fadeIn()
        $(".fire-confirm-page").css("display", "flex")
        player = $(this).attr("data-player");
    })

    $(document).on("click", "#fire-employee", function(){
        $(".pop-up-wrapper").fadeOut()
        $(".fire-confirm-page").fadeOut()
        $("body").fadeOut()
        if (!player) return;
        $.post(`https://${GetParentResourceName()}/fireEmployee`, JSON.stringify(player))
    })

    $(document).on("click", ".buy-vehicle-btn", function(){ 
        $(".pop-up").hide()
        $(".pop-up-wrapper").fadeIn()
        $(".buy-vehicle-page").fadeIn()
        $(".buy-vehicle-page").css("display", "flex")
        vehPrice = $(this).parent().attr("data-vehPrice");
        $("#vehicle-buy-text").text(`Are you sure you want to buy this vehicle for $${vehPrice}?`)
        vehicle = $(this).parent().attr("data-vehicle");
    })

    $(document).on("click", "#buy-vehicle", function(){ 
        if (!vehicle) return;
        $(".pop-up-wrapper").fadeOut()
        $(".buy-vehicle-page").fadeOut()
        $("body").fadeOut()
        $.post(`https://${GetParentResourceName()}/buyVehicle`, JSON.stringify(vehicle))
    })

    $(document).on("click", ".sell-vehicle-btn", function(){ 
        $(".pop-up").hide()
        $(".pop-up-wrapper").fadeIn()
        $(".sell-vehicle-page").fadeIn()
        $(".sell-vehicle-page").css("display", "flex")
        vehPrice = $(this).parent().attr("data-vehPrice") / 2;
        $("#vehicle-sell-text").text(`Are you sure you want to sell this vehicle for $${vehPrice}?`)
        vehicle = $(this).parent().attr("data-vehicle");
    })

    $(document).on("click", "#sell-vehicle", function(){ 
        if (!vehicle) return;
        $(".pop-up-wrapper").fadeOut()
        $(".sell-vehicle-page").fadeOut()
        $("body").fadeOut()
        $.post(`https://${GetParentResourceName()}/sellVehicle`, JSON.stringify(vehicle))
    })

    $(document).on("click", "#accept-invite", function(){ 
        if (invitedStation == null) return;
        $(".pop-up-wrapper").fadeOut()
        $(".invite-employee").fadeOut()
        $(".body").fadeOut()
        $.post(`https://${GetParentResourceName()}/acceptInvite`, JSON.stringify(invitedStation))
    })

    $(document).on("click", "#reject-invite", function(){ 
        if (invitedStation == null) return;
        $(".pop-up-wrapper").fadeOut()
        $(".invite-employee").fadeOut()
        $(".body").fadeOut()
        $.post(`https://${GetParentResourceName()}/rejectInvite`, JSON.stringify(invitedStation))
    })

    $(document).on("click", ".hire-btn", function(){ 
        $(".pop-up").hide()
        $(".pop-up-wrapper").fadeIn()
        $(".invite-employee").fadeIn()
        $(".invite-employee").css("display", "flex")
    })

    $(document).on("click", "#invite-employee", function(){ 
        let id = $("#employee-id-input").val();
        if (id == "") return;
        $(".pop-up-wrapper").fadeOut()
        $(".invite-employee").fadeOut()
        $.post(`https://${GetParentResourceName()}/inviteEmployee`, JSON.stringify(id))
    })

    $(document).on("click", ".sell-btn", function(){ 
        $(".pop-up").hide()
        $(".pop-up-wrapper").fadeIn()
        $(".sell-confirm-page").fadeIn()
        $(".sell-confirm-page").css("display", "flex")
    })

    $(document).on("click", "#sell-station", function(){ 
        $(".pop-up-wrapper").fadeOut()
        $(".sell-confirm-page").fadeOut()
        $("body").fadeOut(200)
        $.post(`https://${GetParentResourceName()}/sellStation`)
    })

    $(document).on("click", ".cancel-btn", function(){ 
        $(".pop-up").fadeOut()
        $(".pop-up-wrapper").fadeOut()
    })

    $(document).on("click", "#save-btn", function(){ 
        let price = $("#liter-price-input").val();
        if (price == "") return;

        let firstLetter = price.toString().charAt(0);
        if (firstLetter == ".") price = "0"+price;

        if (price < 0) return;

        $.post(`https://${GetParentResourceName()}/savePrice`, JSON.stringify(price))
        $("#liter-price-input").val("");
        $("#liter-price-input").attr("placeholder", "$"+price);
    })

    $(document).on("click", "#withdraw-btn", function(){ 
        let balance = $("#balance-input").val();
        if (balance == "") return;

        let firstLetter = balance.toString().charAt(0);
        if (firstLetter == ".") return;

        balance = parseInt(balance);
        if (balance < 0) return;

        $.post(`https://${GetParentResourceName()}/withdraw`, JSON.stringify(balance), function(cb){
            if(cb || cb == 0){
                $("#balance-input").val("");
                $("#balance-input").attr("placeholder", "$"+cb);
                $("#station-balance").text("$"+cb);
            }
        })
    })

    $(document).on("click", "#deposit-btn", function(){ 
        let balance = $("#balance-input").val();
        if (balance == "") return;

        let firstLetter = balance.toString().charAt(0);
        if (firstLetter == ".") return;

        balance = parseInt(balance);
        if (balance < 0) return;

        $.post(`https://${GetParentResourceName()}/deposit`, JSON.stringify(balance), function(cb){
            if(cb || cb == 0){
                $("#balance-input").val("");
                $("#balance-input").attr("placeholder", "$"+cb);
                $("#station-balance").text("$"+cb);
            }
        })
    })

    window.addEventListener("message", function(event){
        let data = event.data;

        switch(data.action){
            case "open":
                let station = data.station;
                let orders = Object.values(data.station.orders);
                let employees = Object.values(data.station.employees);
                let vehicles = Object.values(data.station.vehicles);
                let cfgVehicles = Object.values(data.cfgVehicles);
                let isOwner = data.isOwner;

                $("#balance-input").attr("placeholder", "$"+station.balance);
                $("#station-balance").text("$"+station.balance);
                $("#liter-price-input").attr("placeholder", "$"+station.DefaultPrice);
                $("#max-capacity").text(station.Capacity+"L");
                $("#station-fuel-amount").text((station.fuel).toFixed(1)+"L");
                $("#fuel-bar-svg").attr("height", convertValue(station.fuel, 0, station.Capacity, 0, 150));
                $("#fuel-bar-svg").attr("viewBox", `0 0 60 ${convertValue(station.fuel, 0, station.Capacity, 0, 150)}`);

                $("#orders-table").html("");
                $("#employees-table").html("");
                $(".vehicle-wrapper").html("");

                for (i = 0; i < employees.length; i++) {
                    $("#employees-table").append(`
                        <div class="tr">
                            <div class="td">${employees[i].name}</div>
                            <div class="td">${employees[i].rank}</div>
                            <div class="td">${employees[i].orders}</div>
                            ${isOwner && data.myLicense != employees[i].license ? `<div class="td"><div class="btn fire-employee" data-player="${employees[i].license}">FIRE</div></div>` : '<div class="td"></div>'}
                        </div>
                    `);
                }

                for (i = 0; i < orders.length; i++) {
                    if (!orders[i].accepted){
                        $("#orders-table").append(`
                            <div class="tr">
                                <div class="td">${orders[i].id}</div>
                                <div class="td">${orders[i].vehicle.Name}</div>
                                <div class="td">${orders[i].creatorName}</div>
                                <div class="td"><div class="btn claim-order-btn" data-orderid="${orders[i].id}">ACCEPT</div></div>
                            </div>
                        `); 
                    }
                }

                for (i = 0; i < cfgVehicles.length; i++) {
                    let vehicle = cfgVehicles[i];
                    let isOwned = false

                    for (j = 0; j < vehicles.length; j++) {
                        if (vehicles[j].Name == vehicle.Name) {
                            isOwned = true
                            break
                        }
                    }

                    $(".vehicle-wrapper").append(`
                        <div class="vehicle" data-vehicle="${vehicle.Name}" data-vehPrice="${vehicle.Price}">
                            <div class="vehicle-title">
                                <div class="name">${vehicle.Name}</div>
                                <div class="capacity">(${vehicle.Capacity}L)</div>
                            </div>
                            <div class="veh-img"><img src="assets/vehicles/${vehicle.imgName}"></div>
                            <div class="buy-btn ${isOwned ? "sell-vehicle-btn" : "buy-vehicle-btn"}">${isOwned ? "SELL" : "BUY"}</div>
                        </div>
                    `);
                }

                $("#vehicles-select").html("")
                $("#vehicles-select").append('<option value="0">Select a vehicle</option>')

                for (i = 0; i < vehicles.length; i++){
                    let vehicle = vehicles[i];
                    $("#vehicles-select").append(`<option value="${vehicle.Name}">${vehicle.Name} (${vehicle.Capacity}L)</option>`)
                }
                
                $(".header .btn").hide();
                $(".search-bar").hide();
                $(".header .sell-btn").show();
                $(".page").hide();
                $(".refuel-box").hide();
                $(".page:first-child").show();
                $(".nav-item").removeClass("active");
                $(".nav-item:first-child").addClass("active");
                $("main").show();
                $("body").fadeIn(300);

                break;
            case "sendInvite":
                $("main").hide()
                $(".pop-up").hide()
                $(".pop-up-wrapper").fadeIn()
                $(".receive-invite").fadeIn()
                $(".receive-invite").css("display", "flex")

                $("#invite-title").text("You have been invited by "+ data.senderName +" to get hired.");
                invitedStation = data.station;
                $("body").fadeIn()
                break;
            default:
                break;
        }
    })

    $(document).keyup(function(e) {
        if (e.key === "Escape") {
            $.post(`https://${GetParentResourceName()}/close`)
            $("body").fadeOut(200)
        }
    });
})