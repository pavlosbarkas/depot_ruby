import React from "react";

class PayTypeSelector extends React.Component {
    render() {
        return (
            <div className="field">
                <label htmlFor="order_pay_type">Pay type</label>
                <select id="order_pay_type" name="order[pay_type]">
                    <option value="">Select a payment method</option>
                    <option value="Check">Check</option>
                    <option value="Credit Card">Credit Card</option>
                    <option value="Purchase Order">Purchase Order</option>
                </select>
            </div>
        );
    }
}

export default PayTypeSelector;
