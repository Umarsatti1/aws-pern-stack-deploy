import { Fragment, useState } from "react";


const EditItems = ({list}) => {
    
    const [description, setDescription] = useState(list.description);

    const updateDescription = async e => {
        e.preventDefault();
        try {
            const body = {description};
            const response = await fetch(`/todos/${list.todo_id}`, {
                method: "PUT",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(body)
            });

            window.location = "/";
        } catch (err) {
            console.error(err.message);
        }
    }

    return (
        <Fragment>
            <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target={`#id${list.todo_id}`}>
                Edit
            </button>

            <div class="modal" id={`id${list.todo_id}`} onClick={() => setDescription(list.description)}>
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Edit Item</h4>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" onClick={() => setDescription(list.description)}></button>
                    </div>
                    <div class="modal-body">
                        <input type="text" className="form-control" value={description} onChange={e => setDescription(e.target.value)}/>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-warning" data-bs-dismiss="modal" onClick={e => updateDescription(e)}>
                            Edit
                        </button>
                        <button type="button" class="btn btn-danger" data-bs-dismiss="modal" onClick={() => setDescription(list.description)}>
                            Close
                        </button>
                    </div>
                </div>
            </div>
            </div>
        </Fragment>
    )
};

export default EditItems;