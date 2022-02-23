import React from "react";

import NoPayType from './NoPayType'
import CreditCardPayType from './CreditCardPayType'
import CheckPayType from './CheckPayType'
import PurchaseOrderPayType from './PurchaseOrderPayType'

class PayTypeSelector extends React.Component {

    //make a constructor so that the bind and the state are set for sure before the event handler fires
    constructor(props) {
        super(props);
        //bind "this" so that it will have the value we want when used in an event handler
        this.onPayTypeSelected = this.onPayTypeSelected.bind(this);
        this.state = {selectedPayType: null};
    }

    render() {

        //depending on the selection from the dropdown we choose the needed component
        let PayTypeCustomComponent = NoPayType;
        if (this.state.selectedPayType == "Credit Card"){
            PayTypeCustomComponent = CreditCardPayType;
        }else if (this.state.selectedPayType == "Check"){
            PayTypeCustomComponent = CheckPayType;
        }else if (this.state.selectedPayType == "Purchase Order"){
            PayTypeCustomComponent = PurchaseOrderPayType;
        }

        return (
            <div>
                <div className="field">
                    <label htmlFor="order_pay_type">{I18n.t("orders.form.pay_type")}</label>
                    <select onChange={this.onPayTypeSelected} id="order_pay_type" name="order[pay_type]">
                        <option value="">{I18n.t("orders.form.pay_prompt_html")}</option>
                        <option value="Check">{I18n.t("orders.form.pay_types.check")}</option>
                        <option value="Credit Card">{I18n.t("orders.form.pay_types.credit_card")}</option>
                        <option value="Purchase Order">{I18n.t("orders.form.pay_types.purchase_order")}</option>
                    </select>
                </div>
                <PayTypeCustomComponent />
            </div>
        );
        //the PayTypeCustomComponent is wrapped in a div due to the way our CSS works.
    }

    onPayTypeSelected(event) {
        this.setState({selectedPayType: event.target.value});
    }
}

export default PayTypeSelector;
