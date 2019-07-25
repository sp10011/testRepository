({
    init: function (cmp, event, helper) {
        var street = cmp.get('v.simpleRecord').BillingStreet;
        var city = cmp.get('v.simpleRecord').BillingCity;
        var state = cmp.get('v.simpleRecord').BillingState;
        cmp.set('v.isLoaded',true);
        cmp.set('v.mapMarkers', [
            {
                location: {
                    Street: street,
                    City: city,
                    State: state
                },

                title: 'My House',
                description: 'No Description'
            }
        ]);
        cmp.set('v.zoomLevel', 16);
    }
})