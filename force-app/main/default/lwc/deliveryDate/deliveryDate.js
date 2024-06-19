import {LightningElement, api, wire, track} from 'lwc';
import {CartSummaryAdapter} from "commerce/cartApi";
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import getDeliveryDateByCartId from "@salesforce/apex/DeliveryDateController.getDeliveryDateByCartId";

export default class deliveryDate extends LightningElement {
    
    @track deliveryDate;
   
    @api 
    get cartId(){
        return this._cartId;
    }
    set cartId(val){
        this._cartId = val;
    }

    @wire(CartSummaryAdapter)
    setCartSummary({data, error}) {

        if(!data) {
            console.error(error);
            this.showErrorNotification('Cart Id not found.');
            return;
        }

        this.cartId = data.cartId;
        this.setDeliveryDate();

    }

    async setDeliveryDate() {
        
        getDeliveryDateByCartId({cartId : this.cartId})
        .then(result => {

            if(result && !result.toString().includes('Error')) {
                this.deliveryDate = result;
                return;
            }
    
            this.deliveryDate = '';
            this.showErrorNotification(result.replace('Error: ', ''))

        });

    }

    showErrorNotification(message) {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error!',
            message: message,
            variant: 'error',
        }));
    }
    
}
