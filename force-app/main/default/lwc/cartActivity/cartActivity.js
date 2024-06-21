import {LightningElement, track} from 'lwc';
import {subscribe} from 'lightning/empApi';

export default class CartActivity extends LightningElement {

    @track _checkoutsInProgress = [];

    channelName = '/event/Checkout_Intermediate_Notification__e';
    subscription = {};

    connectedCallback() {
        this.handleSubscribe();
    }

    handleSubscribe() {

        const self = this;

        const messageCallback = (response) => {
            
            if(!response) return;

            self.payload = JSON.stringify(response);
            
            self._checkoutsInProgress.push(JSON.parse(self.payload));
        
        };
        
        subscribe(this.channelName, -1, messageCallback)
        .then(response => {
            this.subscription = response;
        });

    }

}
